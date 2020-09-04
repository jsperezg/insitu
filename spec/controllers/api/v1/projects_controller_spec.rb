# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for :project
  end

  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  let(:user) { User.first || create(:user) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all projects as @projects' do
      project = Project.create! valid_attributes
      get :index, format: :json
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project as @project' do
      project = Project.create! valid_attributes
      get :show, params: {id: project.to_param }, format: :json
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect do
          post :create, params: { project: valid_attributes }, format: :json
        end.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, params: { project: valid_attributes }, format: :json
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { project: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, params: { user_id: user.id, project: invalid_attributes }, format: :json
        expect(assigns(:project)).to be_a_new(Project)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :project
      end

      let(:project) { Project.create! valid_attributes }

      it 'updates the requested project' do
        put :update, params: { id: project.to_param, project: new_attributes }, format: :json
        project.reload

        new_attributes.each do |key, value|
          expect(project[key]).to eq(value)
        end
      end

      it 'assigns the requested project as @project' do
        put :update, params: { user_id: user.id, id: project.to_param, project: valid_attributes }, format: :json
        expect(assigns(:project)).to eq(project)
      end

      it 'returns 200 - ok' do
        put :update, params: { id: project.to_param, project: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the project as @project' do
        project = Project.create! valid_attributes
        put :update, params: { user_id: user.id, id: project.to_param, project: invalid_attributes }, format: :json
        expect(assigns(:project)).to eq(project)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: project.to_param }, format: :json
      end.to change(Project, :count).by(-1)
    end

    it 'returns 200 - ok' do
      project = Project.create! valid_attributes
      delete :destroy, params: { id: project.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
