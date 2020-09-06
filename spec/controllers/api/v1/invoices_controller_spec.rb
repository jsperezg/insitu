# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Invoice. As you add validations to Invoice, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    invoice = attributes_for(:invoice)

    invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
  end

  let(:invalid_attributes) do
    attributes_for(:invoice, date: nil)
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
    it 'assigns all invoices as @invoices' do
      invoice = Invoice.create! valid_attributes
      get :index, format: :json

      expect(assigns(:invoices)).to eq([invoice])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested invoice as @invoice' do
      invoice = Invoice.create! valid_attributes
      get :show, params: { id: invoice.to_param }, format: :json
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Invoice' do
        expect do
          post :create, params: { invoice: valid_attributes }, format: :json
        end.to change(Invoice, :count).by(1)
      end

      it 'assigns a newly created invoice as @invoice' do
        post :create, params: { invoice: valid_attributes }, format: :json
        expect(assigns(:invoice)).to be_a(Invoice)
        expect(assigns(:invoice)).to be_persisted
      end

      it 'returns HTTP 200' do
        post :create, params: { invoice: valid_attributes, user_id: user.id }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved invoice as @invoice' do
        post :create, params: { invoice: invalid_attributes }, format: :json
        expect(assigns(:invoice)).to be_a_new(Invoice)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:invoice)
      end

      it 'updates the requested invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, params: { id: invoice.to_param, invoice: new_attributes }, format: :json
        invoice.reload

        new_attributes.each do |key, value|
          expect(invoice[key]).to eq(value), "#{key}, #{invoice[key]} != #{value}" unless key == :irpf
        end
      end

      it 'assigns the requested invoice as @invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, params: { id: invoice.to_param, invoice: valid_attributes }, format: :json
        expect(assigns(:invoice)).to eq(invoice)
      end

      it 'Returns HTTP 200' do
        invoice = Invoice.create! valid_attributes
        put :update, params: { id: invoice.to_param, invoice: valid_attributes, user_id: user.id }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the invoice as @invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, params: { id: invoice.to_param, invoice: invalid_attributes }, format: :json
        expect(assigns(:invoice)).to eq(invoice)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested invoice' do
      invoice = Invoice.create! valid_attributes
      expect do
        delete :destroy, params: { id: invoice.to_param }, format: :json
      end.to change(Invoice, :count).by(-1)
    end

    it 'Returns HTTP 200' do
      invoice = Invoice.create! valid_attributes
      delete :destroy, params: { id: invoice.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #cancel' do
    it 'creates an amending invoice' do
      invoice = Invoice.create! valid_attributes
      delete :cancel, params: { id: invoice.to_param, user_id: user.id }, format: :json
      expect(assigns(:invoice)).to be_amending_invoice
    end
  end
end
