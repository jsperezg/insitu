# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for :customer
  end

  let(:invalid_attributes) do
    { name: '' }
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
    it 'assigns all customers as @customers' do
      customer = Customer.create! valid_attributes
      get :index, format: :json
      expect(assigns(:customers)).to eq([customer])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested customer as @customer' do
      customer = Customer.create! valid_attributes
      get :show, params: { id: customer.to_param }, format: :json
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Customer' do
        expect do
          post :create, params: { customer: valid_attributes }, format: :json
        end.to change(Customer, :count).by(1)
      end

      it 'assigns a newly created customer as @customer' do
        post :create, params: { customer: valid_attributes }, format: :json
        expect(assigns(:customer)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { customer: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved customer as @customer' do
        post :create, params: { customer: invalid_attributes }, format: :json
        expect(assigns(:customer)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :customer
      end

      let(:customer) { Customer.create! valid_attributes }

      it 'updates the requested customer' do
        put :update, params: { id: customer.to_param, customer: new_attributes }, format: :json
        customer.reload

        new_attributes.each do |key, value|
          expect(customer[key]).to eq(value)
        end
      end

      it 'assigns the requested customer as @customer' do
        put :update, params: { id: customer.to_param, customer: valid_attributes }, format: :json
        expect(assigns(:customer)).to eq(customer)
      end

      it 'returns 200 - ok' do
        put :update, params: { id: customer.to_param, customer: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the customer as @customer' do
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: invalid_attributes }, format: :json
        expect(assigns(:customer)).to eq(customer)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested customer' do
      customer = Customer.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: customer.to_param }, format: :json
      end.to change(Customer, :count).by(-1)
    end

    it 'returns 200 - ok' do
      customer = Customer.create! valid_attributes
      delete :destroy, params: { user_id: user.id, id: customer.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
