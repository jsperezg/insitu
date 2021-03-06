# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethodsController, type: :controller do
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
      get :index, params: { user_id: user.id }
      expect(assigns(:payment_methods)).to include(payment_method)
    end
  end

  describe 'GET #new' do
    it 'assigns a new payment_method as @payment_method' do
      get :new, params: { user_id: user.id }
      expect(assigns(:payment_method)).to be_a_new(PaymentMethod)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested payment_method as @payment_method' do
      payment_method = PaymentMethod.create! valid_attributes
      get :edit, params: { user_id: user.id, id: payment_method.to_param }
      expect(assigns(:payment_method)).to eq(payment_method)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new PaymentMethod' do
        expect do
          post :create, params: { user_id: user.id, payment_method: valid_attributes }
        end.to change(PaymentMethod, :count).by(1)
      end

      it 'assigns a newly created payment_method as @payment_method' do
        post :create, params: { user_id: user.id, payment_method: valid_attributes }
        expect(assigns(:payment_method)).to be_persisted
      end

      it 'redirects to the created payment_method' do
        post :create, params: { user_id: user.id, payment_method: valid_attributes }
        expect(response).to redirect_to(user_payment_methods_url(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved payment_method as @payment_method' do
        post :create, params: { user_id: user.id, payment_method: invalid_attributes }
        expect(assigns(:payment_method)).to be_a_new(PaymentMethod)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user_id: user.id, payment_method: invalid_attributes }
        expect(response).to render_template('new')
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
        put :update, params: { user_id: user.id, id: payment_method.to_param, payment_method: new_attributes }
        payment_method.reload
        expect(payment_method[:name]).to eq(new_attributes[:name])
        expect(payment_method[:note_for_invoice]).to eq(new_attributes[:note_for_invoice])
      end

      it 'assigns the requested payment_method as @payment_method' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { user_id: user.id, id: payment_method.to_param, payment_method: valid_attributes }
        expect(assigns(:payment_method)).to eq(payment_method)
      end

      it 'redirects to the payment_method' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { user_id: user.id, id: payment_method.to_param, payment_method: valid_attributes }
        expect(response).to redirect_to(user_payment_methods_url(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns the payment_method as @payment_method' do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { user_id: user.id, id: payment_method.to_param, payment_method: invalid_attributes }
        expect(assigns(:payment_method)).to eq(payment_method)
      end

      it "re-renders the 'edit' template" do
        payment_method = PaymentMethod.create! valid_attributes
        put :update, params: { user_id: user.id, id: payment_method.to_param, payment_method: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested payment_method' do
      payment_method = PaymentMethod.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: payment_method.to_param }
      end.to change(PaymentMethod, :count).by(-1)
    end

    it 'redirects to the payment_methods list' do
      payment_method = PaymentMethod.create! valid_attributes
      delete :destroy, params: { user_id: user.id, id: payment_method.to_param }
      expect(response).to redirect_to(user_payment_methods_url(user.id))
    end
  end
end
