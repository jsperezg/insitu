# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EstimateStatusesController, type: :controller do
  let(:valid_attributes) do
    { name: 'Estimate status' }
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
    it 'assigns all estimate statuses as @estimate_statuses' do
      estimate_status = EstimateStatus.create(valid_attributes)

      get :index, format: :json
      expect(assigns(:estimate_statuses)).to include(estimate_status)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested estimate status as @estimate_status' do
      estimate_status = EstimateStatus.create(valid_attributes)

      get :show, id: estimate_status.id, format: :json
      expect(assigns(:estimate_status)).to eq(estimate_status)
    end
  end
end
