# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitsController, type: :controller do
  let(:valid_attributes) { attributes_for :unit }

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
      get :index, params: { user_id: user.id }
      expect(assigns(:units)).to include(unit)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested unit as @unit' do
      unit = Unit.create! valid_attributes
      get :show, params: { id: unit.to_param, user_id: user.id }
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe 'GET #new' do
    it 'assigns a new unit as @unit' do
      get :new, params: { user_id: user.id }
      expect(assigns(:unit)).to be_a_new(Unit)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested unit as @unit' do
      unit = Unit.create! valid_attributes
      get :edit, params: { id: unit.to_param, user_id: user.id }
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Unit' do
        expect do
          post :create, params: { unit: valid_attributes, user_id: user.id }
        end.to change(Unit, :count).by(1)
      end

      it 'assigns a newly created unit as @unit' do
        post :create, params: { unit: valid_attributes, user_id: user.id }
        expect(assigns(:unit)).to be_persisted
      end

      it 'redirects to the units list' do
        post :create, params: { unit: valid_attributes, user_id: user.id }
        expect(response).to redirect_to(user_units_path(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved unit as @unit' do
        post :create, params: { unit: invalid_attributes, user_id: user.id }
        expect(assigns(:unit)).to be_a_new(Unit)
      end

      it "re-renders the 'new' template" do
        post :create, params: { unit: invalid_attributes, user_id: user.id }
        expect(response).to render_template('new')
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
        put :update, params: { id: unit.to_param, unit: new_attributes, user_id: user.id }
        unit.reload

        expect(unit[:label_short]).to eq(new_attributes[:label_short])
        expect(unit[:label_long]).to eq(new_attributes[:label_long])
      end

      it 'assigns the requested unit as @unit' do
        put :update, params: { id: unit.to_param, unit: valid_attributes, user_id: user.id }
        expect(assigns(:unit)).to eq(unit)
      end

      it 'redirects to the unit' do
        put :update, params: { id: unit.to_param, unit: valid_attributes, user_id: user.id }
        expect(response).to redirect_to(user_units_path(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns the unit as @unit' do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: invalid_attributes, user_id: user.id }
        expect(assigns(:unit)).to eq(unit)
      end

      it "re-renders the 'edit' template" do
        unit = Unit.create! valid_attributes
        put :update, params: { id: unit.to_param, unit: invalid_attributes, user_id: user.id }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested unit' do
      unit = Unit.create! valid_attributes
      expect do
        delete :destroy, params: { id: unit.to_param, user_id: user.id }
      end.to change(Unit, :count).by(-1)
    end

    it 'redirects to the units list' do
      unit = Unit.create! valid_attributes
      delete :destroy, params: { id: unit.to_param, user_id: user.id }
      expect(response).to redirect_to(user_units_url(user.id))
    end
  end
end
