class Api::V1::ProjectStatusesController < ApiController
  include Api

  before_action :set_project_status, only: [:show]

  def index
    @project_statuses = ProjectStatus.all
  end

  def show
  end

  private

  def set_project_status
    @project_status = ProjectStatus.find(params[:id])
  end
end