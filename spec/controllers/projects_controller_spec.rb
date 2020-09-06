# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:valid_attributes) { attributes_for :project }
  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  before do
    sign_in user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all projects as @projects' do
      project = Project.create! valid_attributes
      get :index, params: { user_id: user.id }
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :show, params: { user_id: user.id, id: project.to_param }
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET #new' do
    before do
      ProjectStatus.find_by(name: 'project_status.active') || ProjectStatus.create!(name: 'project_status.active')
    end

    it 'assigns a new project as @project' do
      get :new, params: { user_id: user.id }
      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'Has a default status' do
      get :new, params: { user_id: user.id }
      expect(assigns(:project).project_status.try(:name)).to eq('project_status.active')
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :edit, params: { user_id: user.id, id: project.to_param }
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect do
          post :create, params: { user_id: user.id, project: valid_attributes }
        end.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, params: { user_id: user.id, project: valid_attributes }
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the projects list' do
        post :create, params: { user_id: user.id, project: valid_attributes }
        expect(response).to redirect_to(user_projects_url(user))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, params: { user_id: user.id, project: invalid_attributes }
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user_id: user.id, project: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { attributes_for :project }
      let(:project) { Project.create! valid_attributes }

      it 'updates the requested project' do
        put :update, params: { user_id: user.id, id: project.to_param, project: new_attributes }
        project.reload

        new_attributes.each do |key, value|
          expect(project[key]).to eq(value)
        end
      end

      it 'assigns the requested project as @project' do
        put :update, params: { user_id: user.id, id: project.to_param, project: valid_attributes }
        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the projects list' do
        put :update, params: { user_id: user.id, id: project.to_param, project: valid_attributes }
        expect(response).to redirect_to(user_projects_url(user))
      end
    end

    context 'with invalid params' do
      it 'assigns the project as @project' do
        project = Project.create! valid_attributes
        put :update, params: { user_id: user.id, id: project.to_param, project: invalid_attributes }
        expect(assigns(:project)).to eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        put :update, params: { user_id: user.id, id: project.to_param, project: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: project.to_param }
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      project = Project.create! valid_attributes
      delete :destroy, params: { user_id: user.id, id: project.to_param }
      expect(response).to redirect_to(user_projects_url(user))
    end
  end
end
