# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EstimatesController, type: :controller do
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

  let(:user) { User.first || create(:user) }
  let(:valid_session) { {} }

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
      get :index
      expect(assigns(:estimates)).to eq([estimate])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested estimate as @estimate' do
      estimate = Estimate.create! valid_attributes
      get :show, params: { id: estimate.to_param }, format: :json
      expect(assigns(:estimate)).to eq(estimate)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Estimate' do
        expect do
          post :create, params: { estimate: valid_attributes }, format: :json
        end.to change(Estimate, :count).by(1)
      end

      it 'assigns a newly created estimate as @estimate' do
        post :create, params: { estimate: valid_attributes }, format: :json
        expect(assigns(:estimate)).to be_a(Estimate)
        expect(assigns(:estimate)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { estimate: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved estimate as @estimate' do
        post :create, params: { estimate: invalid_attributes }, format: :json
        expect(assigns(:estimate)).to be_a_new(Estimate)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:estimate) { create(:estimate) }
      let(:new_attributes) do
        {
          date: Date.current.beginning_of_year + 10.days,
          customer_id: create(:customer).id,
          valid_until: Date.today + 60.days,
          estimate_status_id: EstimateStatus.sent.id
        }
      end

      it 'updates the requested estimate' do
        put :update, params: { id: estimate.to_param, estimate: new_attributes }, format: :json
        estimate.reload

        new_attributes.each do |key, value|
          expect(estimate[key]).to eq(value)
        end
      end

      it 'assigns the requested estimate as @estimate' do
        put :update, params: { id: estimate.to_param, estimate: valid_attributes }, format: :json
        expect(assigns(:estimate)).to eq(estimate)
      end

      it 'returns 200 - ok' do
        put :update, params: { id: estimate.to_param, estimate: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the estimate as @estimate' do
        estimate = Estimate.create! valid_attributes
        put :update, params: { id: estimate.to_param, estimate: invalid_attributes }, format: :json
        expect(assigns(:estimate)).to eq(estimate)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested estimate' do
      estimate = Estimate.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: estimate.to_param }, format: :json
      end.to change(Estimate, :count).by(-1)
    end

    it 'returns 200 - ok' do
      estimate = Estimate.create! valid_attributes
      delete :destroy, params: { user_id: user.id, id: estimate.to_param }, format: :json
      expect(response).to have_http_status(:ok)
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

      get :invoice, params: { user_id: user, id: estimate.to_param }, format: :json
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('estimates.nothing_to_invoice'))
    end

    it 'Generates invoice ' do
      estimate = Estimate.create! valid_attributes

      get :invoice, params: { user_id: user, id: estimate.to_param }, format: :json

      estimate.reload

      estimate.estimate_details.each do |details|
        expect(details.invoice_detail_id).not_to be_nil

        expect(details.invoice_detail.description).to eq(details.description)
        expect(details.invoice_detail.quantity).to eq(details.quantity)
        expect(details.invoice_detail.service_id).to eq(details.service_id)
        expect(details.invoice_detail.vat_rate).to eq(details.invoice_detail.service.vat.rate)
        expect(details.invoice_detail.price).to eq(details.price)
      end

      expect(response).to have_http_status(:ok)
    end

    it 'Generates the invoice for spanish customers' do
      user.update_attributes(country: 'ES', tax_id: '48299472R')

      estimate = Estimate.create! valid_attributes
      estimate.customer.update_attributes(irpf: 16)

      get :invoice, params: { user_id: user, id: estimate.to_param }, format: :json

      estimate.reload
      invoice = estimate.estimate_details.first.invoice_detail.invoice

      expect(invoice.irpf).to eq(16)
    end

    it 'Fails when no paying method available' do
      PaymentMethod.delete_all

      estimate = Estimate.create! valid_attributes

      get :invoice, params: { user_id: user, id: estimate.to_param }, format: :json
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['error']).to be_truthy
      expect(json['errors'][0]).to eq(I18n.t('payment_methods.not_found'))
    end
  end
end
