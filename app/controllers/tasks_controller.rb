# frozen_string_literal: true

class TasksController < SecuredController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_project

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task
             .retrieve_project_tasks(params[:project_id])
             .paginate(page: params[:page], per_page: DEFAULT_ITEMS_PER_PAGE)
             .order(finish_date: :asc, priority: :desc, dead_line: :asc)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new(project_id: @project.id)
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to edit_user_project_task_url(current_user, @project, @task), notice: t(:successfully_created, item: t('tasks.task')) }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      redirect_to edit_user_project_task_url(current_user, @project, @task), notice: t(:successfully_updated, item: t('tasks.task'))
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to user_project_tasks_url(current_user, @project), notice: t(:successfully_destroyed, item: t('tasks.task')) }
      format.json { head :no_content }
    end
  end

  # Generate invoice for finished tasks.
  def invoice_finished
    payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
    unless payment_method
      flash[:alert] = t('payment_methods.not_found')
      redirect_to user_project_tasks_path(current_user, @project)
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
      tasks = Task.retrieve_finished_tasks(@project.id)
      tasks.each do |task|
        task.invoice_timelogs_into(invoice)
      end

      if invoice.invoice_details.empty?
        flash[:alert] = t('tasks.no_pending_tasks')
        redirect_to user_project_tasks_path(current_user, @project)
        raise ActiveRecord::Rollback
      else
        redirect_to edit_user_invoice_path(current_user, invoice)
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
        time_logs_attributes: %i[
          id task_id description time_spent date service_id _destroy
        ]
      )
  end
end
