# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProjectStatusesController, type: :controller do
  let(:valid_attributes) do
    { name: 'project status' }
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
    it 'assigns all project statuses as @project_statuses' do
      status = ProjectStatus.create(valid_attributes)

      get :index, format: :json
      expect(assigns(:project_statuses)).to include(status)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project status as @project_status' do
      status = ProjectStatus.create(valid_attributes)

      get :show, params: { id: status.id }, format: :json
      expect(assigns(:project_status)).to eq(status)
    end
  end
end
