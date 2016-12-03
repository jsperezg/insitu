class Api::V1::ProjectsController < ApiController
  include Api

  before_action :set_project, only: [:show, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@project)
    end
  end

  def update
    if @project.update(project_params)
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@project)
    end
  end

  def destroy
    @project.destroy
    render json: ResponseFactory.get_response_for(@project)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :project_status_id, :customer_id)
  end

end