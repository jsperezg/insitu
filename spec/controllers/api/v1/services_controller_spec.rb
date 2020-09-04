# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ServicesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Service. As you add validations to Service, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for :service
  end

  let(:invalid_attributes) do
    attributes = attributes_for :service
    attributes[:price] = nil
    attributes
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
    it 'assigns all services as @services' do
      service = Service.create! valid_attributes
      get :index, format: :json
      expect(assigns(:services)).to include(service)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested service as @service' do
      service = Service.create! valid_attributes
      get :show, params: { id: service.to_param }, format: :json
      expect(assigns(:service)).to eq(service)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Service' do
        expect do
          post :create, params: { service: valid_attributes }, format: :json
        end.to change(Service, :count).by(1)
      end

      it 'assigns a newly created service as @service' do
        post :create, params: { service: valid_attributes }, format: :json
        expect(assigns(:service)).to be_a(Service)
        expect(assigns(:service)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { service: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved service as @service' do
        post :create, params: { service: invalid_attributes }, format: :json
        expect(assigns(:service)).to be_a_new(Service)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        new_attributes = attributes_for :service
        new_attributes[:description] = 'Modified description'
        new_attributes
      end

      let(:service) { Service.create! valid_attributes }

      it 'updates the requested service' do
        put :update, params: { id: service.to_param, service: new_attributes }, format: :json
        service.reload

        new_attributes.each do |key, value|
          expect(service[key]).to eq(value)
        end
      end

      it 'assigns the requested service as @service' do
        put :update, params: { id: service.to_param, service: valid_attributes }, format: :json
        expect(assigns(:service)).to eq(service)
      end

      it 'returns 200 - ok' do
        put :update, params: { id: service.to_param, service: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the service as @service' do
        service = Service.create! valid_attributes
        put :update, params: { id: service.to_param, service: invalid_attributes }, format: :json
        expect(assigns(:service)).to eq(service)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested service' do
      service = Service.create! valid_attributes
      expect do
        delete :destroy, params: { id: service.to_param }, format: :json
      end.to change(Service, :count).by(-1)
    end

    it 'redirects to the services list' do
      service = Service.create! valid_attributes
      delete :destroy, params: { id: service.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
