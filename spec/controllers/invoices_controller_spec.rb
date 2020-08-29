# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
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
      get :index, user_id: user.id

      expect(assigns(:invoices)).to eq([invoice])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested invoice as @invoice' do
      invoice = Invoice.create! valid_attributes
      get :show, id: invoice.to_param, user_id: user.id
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe 'GET #new' do
    it 'assigns a new invoice as @invoice' do
      get :new, user_id: user.id
      expect(assigns(:invoice)).to be_a_new(Invoice)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested invoice as @invoice' do
      invoice = Invoice.create! valid_attributes
      get :edit, id: invoice.to_param, user_id: user.id
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Invoice' do
        expect do
          post :create, invoice: valid_attributes, user_id: user.id
        end.to change(Invoice, :count).by(1)
      end

      it 'assigns a newly created invoice as @invoice' do
        post :create, invoice: valid_attributes, user_id: user.id
        expect(assigns(:invoice)).to be_a(Invoice)
        expect(assigns(:invoice)).to be_persisted
      end

      it 'redirects to the created invoice' do
        post :create, invoice: valid_attributes, user_id: user.id
        expect(response).to redirect_to(edit_user_invoice_url(user, Invoice.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved invoice as @invoice' do
        post :create, invoice: invalid_attributes, user_id: user.id
        expect(assigns(:invoice)).to be_a_new(Invoice)
      end

      it "re-renders the 'new' template" do
        post :create, invoice: invalid_attributes, user_id: user.id
        expect(response).to render_template('new')
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
        put :update, id: invoice.to_param, invoice: new_attributes, user_id: user.id
        invoice.reload

        new_attributes.each do |key, value|
          next if key == :irpf

          expect(invoice[key]).to eq(value), "#{key}, #{invoice[key]} != #{value}"
        end
      end

      it 'assigns the requested invoice as @invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: valid_attributes, user_id: user.id
        expect(assigns(:invoice)).to eq(invoice)
      end

      it 'redirects to the invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: valid_attributes, user_id: user.id
        expect(response).to redirect_to(edit_user_invoice_url(user, invoice))
      end
    end

    context 'with invalid params' do
      it 'assigns the invoice as @invoice' do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: invalid_attributes, user_id: user.id
        expect(assigns(:invoice)).to eq(invoice)
      end

      it "re-renders the 'edit' template" do
        invoice = Invoice.create! valid_attributes
        put :update, id: invoice.to_param, invoice: invalid_attributes, user_id: user.id
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested invoice' do
      invoice = Invoice.create! valid_attributes
      expect do
        delete :destroy, id: invoice.to_param, user_id: user.id
      end.to change(Invoice, :count).by(-1)
    end

    it 'redirects to the invoices list' do
      invoice = Invoice.create! valid_attributes
      delete :destroy, id: invoice.to_param, user_id: user.id
      expect(response).to redirect_to(user_invoices_url(user.id))
    end
  end

  describe 'DELETE #cancel' do
    it 'creates an amending invoice' do
      invoice = Invoice.create! valid_attributes
      delete :cancel, id: invoice.to_param, user_id: user.id
      expect(assigns(:invoice)).to be_amending_invoice
    end

    it 'redirects to the amending invoice' do
      invoice = Invoice.create! valid_attributes
      delete :cancel, id: invoice.to_param, user_id: user.id
      expect(response).to redirect_to(edit_user_invoice_url(user, assigns(:invoice)))
    end
  end

  describe 'GET #forward_email' do
    let(:customer_without_email_invoice) do
      customer = create(:customer, contact_email: nil)
      invoice = attributes_for :invoice, customer_id: customer.id
      invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])

      invoice
    end

    it 'fails for customers without email' do
      invoice = Invoice.create! customer_without_email_invoice

      get :forward_email, user_id: user, id: invoice

      expect(response).to redirect_to(user_invoice_path(user.id, invoice.id))
      expect(flash[:error]).to eq(I18n.t('helpers.customer_mail_missing'))
    end
  end
end
