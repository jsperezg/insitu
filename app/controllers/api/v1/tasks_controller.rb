class Api::V1::TasksController < SecuredController
  include Api

  before_action :set_task, only: [:show, :update, :destroy]
  before_action :set_project

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.retrieve_project_tasks(params[:project_id])
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    if @task.save
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@task)
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@task)
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    render json: ResponseFactory.get_response_for(@task)
  end

  # Generate invoice for finished tasks.
  def invoice_finished
    payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
    unless payment_method
      render json: ResponseFactory.error_response(t('payment_methods.not_found'))
      return
    end

    Invoice.transaction do
      invoice = Invoice.create(
          date: Date.today,
          payment_date: Date.today + 15.days,
          customer_id: @project.customer_id,
          payment_method_id: payment_method.id,
          irpf: 0
      )

      invoice.apply_irpf(current_user)

      # Iterate over finished tasks.
      tasks = Task.retrieve_project_tasks(@project.id).where.not(finish_date: :nil)
      tasks.each do |task|
        task.invoice_timelogs_into(invoice)
      end

      if invoice.invoice_details.empty?
        render json: ResponseFactory.error_response(t('tasks.no_pending_tasks'))
        raise ActiveRecord::Rollback
      else
        render json: ResponseFactory.get_response_for(invoice)
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params
        .require(:task)
        .permit(
            :name, :description, :project_id, :finished, :finish_date, :dead_line, :priority,
            time_logs_attributes: [
                :id, :task_id, :description, :time_spent, :date, :service_id, :_destroy
            ]
        )
  end
end
