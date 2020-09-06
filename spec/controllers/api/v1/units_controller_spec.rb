# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UnitsController, type: :controller do
  let(:valid_attributes) { attributes_for(:unit) }

  let(:invalid_attributes) do
    { label_short: nil, label_long: 'Label long' }
  end

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all units as @units' do
      unit = Unit.create! valid_attributes
      get :index, format: :json
      expect(assigns(:units)).to include(unit)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested unit as @unit' do
      unit = Unit.create! valid_attributes
      get :show, params: { id: unit.to_param }, format: :json
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Unit' do
        expect do
          post :create, params: { unit: valid_attributes }, format: :json
        end.to change(Unit, :count).by(1)
      end

      it 'assigns a newly created unit as @unit' do
        post :create, params: { unit: valid_attributes }, format: :json
        expect(assigns(:unit)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, params: { unit: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved unit as @unit' do
        post :create, params: { unit: invalid_attributes }, format: :json
        expect(assigns(:unit)).to be_a_new(Unit)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { label_short: 'updated label short', label_long: 'updated label long' }
      end

      let(:unit) { Unit.create! valid_attributes }

      it 'updates the requested unit' do
        put :update, params: { id: unit.to_param, unit: new_attributes }, format: :json
        unit.reload

        expect(unit[:label_short]).to eq(new_attributes[:label_short])
        expect(unit[:label_long]).to eq(new_attributes[:label_long])
      end

      it 'assigns the requested unit as @unit' do
        put :update, params: { id: unit.to_param, unit: valid_attributes }, format: :json
        expect(assigns(:unit)).to eq(unit)
      end

      it 'returns 200 - ok' do
        put :update, params: { id: unit.to_param, unit: valid_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the unit as @unit' do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: invalid_attributes }, format: :json
        expect(assigns(:unit)).to eq(unit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:unit) { Unit.create! valid_attributes }

    it 'destroys the requested unit' do
      unit = create(:unit)
      expect do
        delete :destroy, params: { id: unit.to_param }, format: :json
      end.to change(Unit, :count).by(-1)
    end

    it 'returns 200 - ok' do
      delete :destroy, params: { id: unit.to_param }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
