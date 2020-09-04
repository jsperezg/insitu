# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
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
      get :index, params: { user_id: user.id }
      expect(assigns(:customers)).to eq([customer])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested customer as @customer' do
      customer = Customer.create! valid_attributes
      get :show, params: { user_id: user.id, id: customer.to_param }
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe 'GET #new' do
    it 'assigns a new customer as @customer' do
      get :new, params: { user_id: user.id }
      expect(assigns(:customer)).to be_a_new(Customer)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested customer as @customer' do
      customer = Customer.create! valid_attributes
      get :edit, params: { user_id: user.id, id: customer.to_param }
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Customer' do
        expect do
          post :create, params: { user_id: user.id, customer: valid_attributes }
        end.to change(Customer, :count).by(1)
      end

      it 'assigns a newly created customer as @customer' do
        post :create, params: { user_id: user.id, customer: valid_attributes }
        expect(assigns(:customer)).to be_a(Customer)
        expect(assigns(:customer)).to be_persisted
      end

      it 'redirects to customers list' do
        post :create, params: { user_id: user.id, customer: valid_attributes }
        expect(response).to redirect_to(user_customers_url(user))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved customer as @customer' do
        post :create, params: { user_id: user.id, customer: invalid_attributes }
        expect(assigns(:customer)).to be_a_new(Customer)
        expect(assigns(:customer)).not_to be_persisted
      end

      it "re-renders the 'new' template" do
        post :create, params: { user_id: user.id, customer: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :customer
      end

      it 'updates the requested customer' do
        customer = Customer.create! valid_attributes
        put :update, params: { user_id: user.id, id: customer.to_param, customer: new_attributes }
        customer.reload

        new_attributes.each do |key, value|
          expect(customer[key]).to eq(value)
        end
      end

      it 'assigns the requested customer as @customer' do
        customer = Customer.create! valid_attributes
        put :update, params: { user_id: user.id, id: customer.to_param, customer: valid_attributes }
        expect(assigns(:customer)).to eq(customer)
      end

      it 'redirects to the customers list' do
        customer = Customer.create! valid_attributes
        put :update, params: { user_id: user.id, id: customer.to_param, customer: valid_attributes }
        expect(response).to redirect_to(user_customers_url(user))
      end
    end

    context 'with invalid params' do
      it 'assigns the customer as @customer' do
        customer = Customer.create! valid_attributes
        put :update, params: { user_id: user.id, id: customer.to_param, customer: invalid_attributes }
        expect(assigns(:customer)).to eq(customer)
      end

      it "re-renders the 'edit' template" do
        customer = Customer.create! valid_attributes
        put :update, params: { user_id: user.id, id: customer.to_param, customer: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested customer' do
      customer = Customer.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: customer.to_param }
      end.to change(Customer, :count).by(-1)
    end

    it 'redirects to the customers list' do
      customer = Customer.create! valid_attributes
      delete :destroy, params: { user_id: user.id, id: customer.to_param }
      expect(response).to redirect_to(user_customers_url(user))
    end
  end

  describe 'POST #csv_import' do
    let(:file) { fixture_file_upload('csv/customers.csv', 'text/csv') }

    it 'Creates a new customer' do
      expect do
        post :csv_import, params: { user_id: user.id, csv_file: file }
      end.to change(Customer, :count).by(2)
    end

    it 'Redirects to services list' do
      post :csv_import, params: { user_id: user.id, csv_file: file }
      expect(response).to redirect_to(user_customers_url(user.id))
    end
  end
end
