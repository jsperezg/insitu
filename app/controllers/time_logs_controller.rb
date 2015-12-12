class TimeLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_time_log, only: [:show, :edit, :update, :destroy]
  before_action :set_task

  # GET /time_logs
  # GET /time_logs.json
  def index
    @time_logs = TimeLog.order(start_time: :desc)
  end

  # GET /time_logs/1
  # GET /time_logs/1.json
  def show
  end

  # GET /time_logs/new
  def new
    @time_log = TimeLog.new(task_id: @task.id)
  end

  # GET /time_logs/1/edit
  def edit
  end

  # POST /time_logs
  # POST /time_logs.json
  def create
    @time_log = TimeLog.new(time_log_params)

    respond_to do |format|
      if @time_log.save
        format.html {
          redirect_to user_project_task_time_logs_path(current_user, params[:project_id], params[:task_id]),
            notice: t(:successfully_created, item: t('time_logs.time_log'))
        }
        format.json { render :show, status: :created, location: @time_log }
      else
        format.html { render :new }
        format.json { render json: @time_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_logs/1
  # PATCH/PUT /time_logs/1.json
  def update
    respond_to do |format|
      if @time_log.update(time_log_params)
        format.html {
          redirect_to user_project_task_time_logs_path(current_user, params[:project_id], params[:task_id]),
            notice: t(:successfully_updated, item: t('time_logs.time_log'))
        }
        format.json { respond_with_bip @time_log }
      else
        format.html { render :edit }
        format.json { respond_with_bip @time_log }
      end
    end
  end

  # DELETE /time_logs/1
  # DELETE /time_logs/1.json
  def destroy
    @time_log.destroy
    respond_to do |format|
      format.html {
          redirect_to user_project_task_time_logs_path(current_user, params[:project_id], params[:task_id]),
            notice: t(:successfully_destroyed, item: t('time_logs.time_log'))
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_log
      @time_log = TimeLog.find(params[:id])
    end

    def set_task
      @task = Task.find(params[:task_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_log_params
      params.require(:time_log).permit(:description, :start_time, :end_time, :task_id, :service_id)
    end
end
