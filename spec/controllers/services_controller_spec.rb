# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
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
      get :index, user_id: user.id
      expect(assigns(:services)).to include(service)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested service as @service' do
      service = Service.create! valid_attributes
      get :show, user_id: user.id, id: service.to_param
      expect(assigns(:service)).to eq(service)
    end
  end

  describe 'GET #new' do
    it 'assigns a new service as @service' do
      get :new, user_id: user.id
      expect(assigns(:service)).to be_a_new(Service)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested service as @service' do
      service = Service.create! valid_attributes
      get :edit, user_id: user.id, id: service.to_param
      expect(assigns(:service)).to eq(service)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Service' do
        expect do
          post :create, user_id: user.id, service: valid_attributes
        end.to change(Service, :count).by(1)
      end

      it 'assigns a newly created service as @service' do
        post :create, user_id: user.id, service: valid_attributes
        expect(assigns(:service)).to be_persisted
      end

      it 'redirects to services list' do
        post :create, user_id: user.id, service: valid_attributes
        expect(response).to redirect_to(user_services_path(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved service as @service' do
        post :create, user_id: user.id, service: invalid_attributes
        expect(assigns(:service)).to be_a_new(Service)
      end

      it "re-renders the 'new' template" do
        post :create, user_id: user.id, service: invalid_attributes
        expect(response).to render_template('new')
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
        put :update, user_id: user.id, id: service.to_param, service: new_attributes
        service.reload

        new_attributes.each do |key, value|
          expect(service[key]).to eq(value)
        end
      end

      it 'assigns the requested service as @service' do
        put :update, user_id: user.id, id: service.to_param, service: valid_attributes
        expect(assigns(:service)).to eq(service)
      end

      it 'redirects to the services list' do
        put :update, user_id: user.id, id: service.to_param, service: valid_attributes
        expect(response).to redirect_to(user_services_path(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns the service as @service' do
        service = Service.create! valid_attributes
        put :update, user_id: user.id, id: service.to_param, service: invalid_attributes
        expect(assigns(:service)).to eq(service)
      end

      it "re-renders the 'edit' template" do
        service = Service.create! valid_attributes
        put :update, user_id: user.id, id: service.to_param, service: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested service' do
      service = Service.create! valid_attributes
      expect do
        delete :destroy, user_id: user.id, id: service.to_param
      end.to change(Service, :count).by(-1)
    end

    it 'redirects to the services list' do
      service = Service.create! valid_attributes
      delete :destroy, user_id: user.id, id: service.to_param
      expect(response).to redirect_to(user_services_url(user.id))
    end
  end

  describe 'POST #csv_import' do
    let(:file) { fixture_file_upload('csv/services.csv', 'text/csv') }

    it 'Creates a new service' do
      expect do
        post :csv_import, user_id: user.id, csv_file: file
      end.to change(Service, :count).by(2)
    end

    it 'Redirects to services list' do
      post :csv_import, user_id: user.id, csv_file: file
      expect(response).to redirect_to(user_services_url(user.id))
    end
  end
end
