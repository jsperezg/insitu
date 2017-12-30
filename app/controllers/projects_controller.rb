# frozen_string_literal: true

# Controller in charge of managing projects
class ProjectsController < SecuredController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  # GET /projects.json
  def index
    authorize! :index, Project

    @filterrific = initialize_filterrific(
      Project,
      params[:filterrific]
    ) || return

    @projects = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    authorize! :show, @project
  end

  # GET /projects/new
  def new
    authorize! :create, Project
    @project = Project.new(project_status: ProjectStatus.find_by(name: 'project_status.active'))
  end

  # GET /projects/1/edit
  def edit
    authorize! :update, @project
  end

  # POST /projects
  # POST /projects.json
  def create
    authorize! :create, Project
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to user_projects_path(current_user), notice: t(:successfully_created, item: t('projects.project')) }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize! :update, @project
    if @project.update(project_params)
      redirect_to user_projects_path(current_user), notice: t(:successfully_updated, item: t('projects.project'))
    else
      render :edit
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    authorize! :destroy, @project
    @project.destroy
    respond_to do |format|
      format.html { redirect_to user_projects_url(current_user), notice: t(:successfully_destroyed, item: t('projects.project')) }
      format.json { head :no_content }
    end
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
