require 'rails-controller-testing'
require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Api::V1::ServicesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Service. As you add validations to Service, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for :service
  }

  let(:invalid_attributes) {
    attributes = attributes_for :service
    attributes[:price] = nil
    attributes
  }

  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    Thread.current[:user] = @user
  end

  after(:each) do
    sign_out @user
  end

  describe 'GET #index' do
    it 'assigns all services as @services' do
      service = Service.create! valid_attributes
      get :index, params: { format: :json }
      expect(assigns(:services)).to include(service)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested service as @service' do
      service = Service.create! valid_attributes
      get :show, params: { id: service.to_param, format: :json }
      expect(assigns(:service)).to eq(service)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Service' do
        expect {
          post :create, params: { service: valid_attributes, format: :json }
        }.to change(Service, :count).by(1)
      end

      it 'assigns a newly created service as @service' do
        post :create, params: { service: valid_attributes, format: :json }
        expect(assigns(:service)).to be_a(Service)
        expect(assigns(:service)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { service: valid_attributes, format: :json }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved service as @service' do
        post :create, params: { service: invalid_attributes }
        expect(assigns(:service)).to be_a_new(Service)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        new_attributes = attributes_for :service
        new_attributes[:description] = 'Modified description'
        new_attributes
      }

      it 'updates the requested service' do
        service = Service.create! valid_attributes
        put :update, params: { id: service.to_param, service: new_attributes }
        service.reload

        new_attributes.each do |key, value|
          expect(service[key]).to eq(value)
        end
      end

      it 'assigns the requested service as @service' do
        service = Service.create! valid_attributes
        put :update, params: { id: service.to_param, service: valid_attributes }
        expect(assigns(:service)).to eq(service)
      end

      it 'returns 200 - ok' do
        service = Service.create! valid_attributes
        put :update, params: { id: service.to_param, :service => valid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the service as @service' do
        service = Service.create! valid_attributes
        put :update, params: { id: service.to_param, service: invalid_attributes }
        expect(assigns(:service)).to eq(service)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested service' do
      service = Service.create! valid_attributes
      expect {
        delete :destroy, params: { id: service.to_param }
      }.to change(Service, :count).by(-1)
    end

    it 'redirects to the services list' do
      service = Service.create! valid_attributes
      delete :destroy, params: { id: service.to_param }
      expect(response).to have_http_status(:ok)
    end
  end
end
