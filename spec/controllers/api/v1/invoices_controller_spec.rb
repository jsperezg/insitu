# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Invoice. As you add validations to Invoice, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    invoice = attributes_for(:invoice)

    invoice.merge(invoice_details_attributes: [ attributes_for(:invoice_detail, invoice_id: nil) ])
  }

  let(:invalid_attributes) {
    attributes_for(:invoice, date: nil)
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
    it 'assigns all invoices as @invoices' do
      invoice = Invoice.create! valid_attributes
      get :index

      expect(assigns(:invoices)).to eq([invoice])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested invoice as @invoice' do
      invoice = Invoice.create! valid_attributes
      get :show, id: invoice.to_param
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Invoice' do
        expect {
          post :create, invoice: valid_attributes
        }.to change(Invoice, :count).by(1)
      end

      it 'assigns a newly created invoice as @invoice' do
        post :create, invoice: valid_attributes
        expect(assigns(:invoice)).to be_a(Invoice)
        expect(assigns(:invoice)).to be_persisted
      end

      it 'returns HTTP 200' do
        post :create, invoice: valid_attributes, user_id: @user.id
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved invoice as @invoice' do
        post :create, invoice: invalid_attributes
        expect(assigns(:invoice)).to be_a_new(Invoice)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        attributes_for(:invoice)
      }

      it 'updates the requested invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: new_attributes
        invoice.reload

        new_attributes.each do |key, value|
          unless key == :irpf
            expect(invoice[key]).to eq(value), "#{key}, #{invoice[key]} != #{value}"
          end
        end
      end

      it 'assigns the requested invoice as @invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: valid_attributes
        expect(assigns(:invoice)).to eq(invoice)
      end

      it 'Returns HTTP 200' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: valid_attributes, user_id: @user.id
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the invoice as @invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: invalid_attributes
        expect(assigns(:invoice)).to eq(invoice)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested invoice' do
      invoice = Invoice.create! valid_attributes
      expect {
        delete :destroy, id: invoice.to_param
      }.to change(Invoice, :count).by(-1)
    end

    it 'Returns HTTP 200' do
      invoice = Invoice.create! valid_attributes
      delete :destroy, id: invoice.to_param
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #cancel' do
    it 'creates an amending invoice' do
      invoice = Invoice.create! valid_attributes
      delete :cancel, id: invoice.to_param, user_id: @user.id
      expect(assigns(:invoice)).to  be_amending_invoice
    end
  end
end
