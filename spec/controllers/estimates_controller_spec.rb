# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EstimatesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Estimate. As you add validations to Estimate, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    estimate = attributes_for(:estimate)

    estimate.merge(estimate_details_attributes: [attributes_for(:estimate_detail, estimate_id: nil)])
  end

  let(:invalid_attributes) do
    attributes_for(:estimate, customer_id: nil)
  end

  let(:valid_session) { {} }
  let(:user) { User.first || create(:user) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all estimates as @estimates' do
      estimate = Estimate.create! valid_attributes
      get :index, user_id: user.id
      expect(assigns(:estimates)).to eq([estimate])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested estimate as @estimate' do
      estimate = Estimate.create! valid_attributes
      get :show, user_id: user.id, id: estimate.to_param
      expect(assigns(:estimate)).to eq(estimate)
    end
  end

  describe 'GET #new' do
    it 'assigns a new estimate as @estimate' do
      get :new, user_id: user.id
      expect(assigns(:estimate)).to be_a_new(Estimate)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested estimate as @estimate' do
      estimate = Estimate.create! valid_attributes
      get :edit, user_id: user.id, id: estimate.to_param
      expect(assigns(:estimate)).to eq(estimate)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Estimate' do
        expect do
          post :create, user_id: user.id, estimate: valid_attributes
        end.to change(Estimate, :count).by(1)
      end

      it 'assigns a newly created estimate as @estimate' do
        post :create, user_id: user.id, estimate: valid_attributes
        expect(assigns(:estimate)).to be_a(Estimate)
        expect(assigns(:estimate)).to be_persisted
      end

      it 'redirects to the created estimate' do
        post :create, user_id: user.id, estimate: valid_attributes
        expect(response).to redirect_to(edit_user_estimate_url(user, Estimate.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved estimate as @estimate' do
        post :create, user_id: user.id, estimate: invalid_attributes
        expect(assigns(:estimate)).to be_a_new(Estimate)
      end

      it "re-renders the 'new' template" do
        post :create, user_id: user.id, estimate: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          date: Date.current.beginning_of_year + 10.days,
          customer_id: create(:customer).id,
          valid_until: Date.today + 60.days,
          estimate_status_id: EstimateStatus.sent.id
        }
      end
      let(:estimate) { create(:estimate) }

      it 'updates the requested estimate' do
        put :update, params: { user_id: user.id, id: estimate.to_param, estimate: new_attributes }
        estimate.reload

        new_attributes.each do |key, value|
          expect(estimate[key]).to eq(value)
        end
      end

      it 'assigns the requested estimate as @estimate' do
        put :update, params: { user_id: user.id, id: estimate.to_param, estimate: valid_attributes }
        expect(assigns(:estimate)).to eq(estimate)
      end

      it 'redirects to the estimate' do
        put :update, params: { user_id: user.id, id: estimate.to_param, estimate: valid_attributes }
        expect(response).to redirect_to(edit_user_estimate_url(user, Estimate.last))
      end
    end

    context 'with invalid params' do
      it 'assigns the estimate as @estimate' do
        estimate = Estimate.create! valid_attributes
        put :update, user_id: user.id, id: estimate.to_param, estimate: invalid_attributes
        expect(assigns(:estimate)).to eq(estimate)
      end

      it "re-renders the 'edit' template" do
        estimate = Estimate.create! valid_attributes
        put :update, user_id: user.id, id: estimate.to_param, estimate: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested estimate' do
      estimate = Estimate.create! valid_attributes
      expect do
        delete :destroy, user_id: user.id, id: estimate.to_param
      end.to change(Estimate, :count).by(-1)
    end

    it 'redirects to the estimates list' do
      estimate = Estimate.create! valid_attributes
      delete :destroy, user_id: user.id, id: estimate.to_param
      expect(response).to redirect_to(user_estimates_url(user))
    end
  end

  describe 'GET #invoice' do
    before do
      PaymentMethod.first || create(:payment_method)
      Service.first || create(:service)
      InvoiceStatus.first || create(:invoice_status)
    end

    it 'Warns when nothing to invoice' do
      estimate = create(:estimate)

      get :invoice, user_id: user, id: estimate
      expect(response).to redirect_to(user_estimates_path(user))
      expect(flash[:alert]).to eq(I18n.t('estimates.nothing_to_invoice'))
    end

    it 'Generates invoice' do
      estimate = Estimate.create! valid_attributes

      get :invoice, user_id: user, id: estimate

      estimate.reload

      estimate.estimate_details.each do |details|
        expect(details.invoice_detail_id).not_to be_nil

        expect(details.invoice_detail.description).to eq(details.description)
        expect(details.invoice_detail.quantity).to eq(details.quantity)
        expect(details.invoice_detail.service_id).to eq(details.service_id)
        expect(details.invoice_detail.vat_rate).to eq(details.invoice_detail.service.vat.rate)
        expect(details.invoice_detail.price).to eq(details.price)
      end

      expect(response).to redirect_to(edit_user_invoice_path(user, estimate.estimate_details.first.invoice_detail.invoice_id))
    end

    it 'Generates the invoice for spanish customers' do
      user.update_attributes(country: 'ES', tax_id: '48299472R')

      estimate = Estimate.create! valid_attributes
      estimate.customer.update_attributes(irpf: 16)

      get :invoice, user_id: user, id: estimate

      estimate.reload
      invoice = estimate.estimate_details.first.invoice_detail.invoice

      expect(invoice.irpf).to eq(16)
    end

    it 'Fails when no paying method available' do
      PaymentMethod.delete_all

      estimate = Estimate.create! valid_attributes

      get :invoice, user_id: user, id: estimate

      expect(response).to redirect_to user_estimates_path(user.id)
      expect(flash[:alert]).to eq(I18n.t('payment_methods.not_found'))
    end
  end

  describe 'GET #forward_email' do
    let(:customer_without_email_estimate) do
      customer = create(:customer, contact_email: nil)
      estimate = attributes_for :estimate, customer_id: customer.id
      estimate.merge(estimate_details_attributes: [attributes_for(:estimate_detail, estimate_id: nil)])

      estimate
    end

    it 'fails for customers without email' do
      estimate = Estimate.create! customer_without_email_estimate

      get :forward_email, user_id: user, id: estimate

      expect(response).to redirect_to(user_estimate_path(user.id, estimate.id))
      expect(flash[:error]).to eq(I18n.t('helpers.customer_mail_missing'))
    end
  end
end
