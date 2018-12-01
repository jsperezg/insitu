# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::VatsController, type: :controller do
  let(:valid_attributes) { attributes_for :vat }
  let(:vat) { Vat.create! valid_attributes }
  let(:invalid_attributes) { attributes_for :vat, rate: -1 }
  let(:user) { User.first || create(:user) }

  before do
    sign_in user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all vats as @vats' do
      vat = Vat.create! valid_attributes
      get :index, format: :json
      expect(assigns(:vats)).to include(vat)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested vat as @vat' do
      vat = Vat.create! valid_attributes
      get :show, id: vat.to_param, format: :json
      expect(assigns(:vat)).to eq(vat)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Vat' do
        expect do
          post :create, vat: valid_attributes, format: :json
        end.to change(Vat, :count).by(1)
      end

      it 'assigns a newly created vat as @vat' do
        post :create, vat: valid_attributes, format: :json
        expect(assigns(:vat)).to be_persisted
      end

      it 'returns 200 - ok' do
        post :create, vat: valid_attributes, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved vat as @vat' do
        post :create, vat: invalid_attributes, format: :json
        expect(assigns(:vat)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { rate: 16 }
      end

      it 'updates the requested vat' do
        put :update, id: vat.to_param, vat: new_attributes, format: :json
        vat.reload

        expect(vat[:label]).to eq(new_attributes[:label])
        expect(vat[:rate]).to eq(new_attributes[:rate])
      end

      it 'assigns the requested vat as @vat' do
        put :update, id: vat.to_param, vat: valid_attributes, response: :json
        expect(assigns(:vat)).to eq(vat)
      end

      it 'returns 200 - ok' do
        put :update, id: vat.to_param, vat: valid_attributes, response: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'assigns the vat as @vat' do
        put :update, id: vat.to_param, vat: invalid_attributes, response: :json
        expect(assigns(:vat)).to eq(vat)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested vat' do
      vat = create(:vat)
      expect do
        delete :destroy, id: vat.to_param, response: :json
      end.to change(Vat, :count).by(-1)
    end

    it 'returns 200 - ok' do
      delete :destroy, id: vat.to_param, response: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
