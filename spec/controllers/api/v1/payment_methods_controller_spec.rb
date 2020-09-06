# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PaymentMethodsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # PaymentMethod. As you add validations to PaymentMethod, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for :payment_method
  end

  let(:invalid_attributes) do
    { name: nil, note_for_invoice: nil }
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
    it 'assigns all payment_methods as @payment_methods' do
      payment_method = PaymentMethod.create! valid_attributes
      get :index, format: :json
      expect(assigns(:payment_methods)).to include(payment_method)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new PaymentMethod' do
        expect do
          post :create, params: { payment_method: valid_attributes }, format: :json
        end.to change(PaymentMethod, :count).by(1)
      end

      it 'assigns a newly created payment_method as @payment_method' do
        post :create, params: { payment_method: valid_attributes }, format: :json
        expect(assigns(:payment_method)).to be_a(PaymentMethod)
        expect(assigns(:payment_method)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { payment_method: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved payment_method as @payment_method' do
        post :create, params: { payment_method: invalid_attributes }, format: :json
        expect(assigns(:payment_method)).to be_a_new(PaymentMethod)
        expect(assigns(:payment_method)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for :payment_method
      end

      it 'updates the requested payment_method' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { id: payment_method.to_param, payment_method: new_attributes }, format: :json
        payment_method.reload
        expect(payment_method[:name]).to eq(new_attributes[:name])
        expect(payment_method[:note_for_invoice]).to eq(new_attributes[:note_for_invoice])
      end

      it 'assigns the requested payment_method as @payment_method' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { id: payment_method.to_param, payment_method: valid_attributes }, format: :json
        expect(assigns(:payment_method)).to eq(payment_method)
      end

      it 'returns 200 - ok' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { id: payment_method.to_param, payment_method: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the payment_method as @payment_method' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { id: payment_method.to_param, payment_method: invalid_attributes }, format: :json
        expect(assigns(:payment_method)).to eq(payment_method)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested payment_method' do
      payment_method = PaymentMethod.create! valid_attributes
      expect do
        delete :destroy, params: { id: payment_method.to_param }, format: :json
      end.to change(PaymentMethod, :count).by(-1)
    end

    it 'returns 200 - ok' do
      payment_method = PaymentMethod.create! valid_attributes
      delete :destroy, params: { id: payment_method.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
