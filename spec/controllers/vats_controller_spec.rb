# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VatsController, type: :controller do
  let(:valid_attributes) { attributes_for :vat }
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
      get :index, user_id: user.id
      expect(assigns(:vats)).to include(vat)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested vat as @vat' do
      vat = Vat.create! valid_attributes
      get :show, id: vat.to_param, user_id: user.id
      expect(assigns(:vat)).to eq(vat)
    end
  end

  describe 'GET #new' do
    it 'assigns a new vat as @vat' do
      get :new, user_id: user.id
      expect(assigns(:vat)).to be_a_new(Vat)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested vat as @vat' do
      vat = Vat.create! valid_attributes
      get :edit, id: vat.to_param, user_id: user.id
      expect(assigns(:vat)).to eq(vat)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Vat' do
        expect do
          post :create, vat: valid_attributes, user_id: user.id
        end.to change(Vat, :count).by(1)
      end

      it 'assigns a newly created vat as @vat' do
        post :create, vat: valid_attributes, user_id: user.id
        expect(assigns(:vat)).to be_persisted
      end

      it 'redirects to the created vat' do
        post :create, vat: valid_attributes, user_id: user.id
        expect(response).to redirect_to(user_vats_path(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved vat as @vat' do
        post :create, vat: invalid_attributes, user_id: user.id
        expect(assigns(:vat)).to be_a_new(Vat)
      end

      it "'re-renders the 'new' template'" do
        post :create, vat: invalid_attributes, user_id: user.id
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { rate: 16 } }

      it 'updates the requested vat' do
        vat = Vat.create! valid_attributes
        put :update, id: vat.to_param, vat: new_attributes, user_id: user.id
        vat.reload

        expect(vat[:rate]).to eq(new_attributes[:rate])
      end

      it 'assigns the requested vat as @vat' do
        vat = Vat.create! valid_attributes
        put :update, id: vat.to_param, vat: valid_attributes, user_id: user.id
        expect(assigns(:vat)).to eq(vat)
      end

      it 'redirects to the vat' do
        vat = Vat.create! valid_attributes
        put :update, id: vat.to_param, vat: valid_attributes, user_id: user.id
        expect(response).to redirect_to(user_vats_path(user.id))
      end
    end

    context 'with invalid params' do
      it 'assigns the vat as @vat' do
        vat = Vat.create! valid_attributes
        put :update, id: vat.to_param, vat: invalid_attributes, user_id: user.id
        expect(assigns(:vat)).to eq(vat)
      end

      it "re-renders the 'edit' template" do
        vat = Vat.create! valid_attributes
        put :update, id: vat.to_param, vat: invalid_attributes, user_id: user.id
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested vat' do
      vat = Vat.create! valid_attributes
      expect do
        delete :destroy, id: vat.to_param, user_id: user.id
      end.to change(Vat, :count).by(-1)
    end

    it 'redirects to the vats list' do
      vat = Vat.create! valid_attributes
      delete :destroy, id: vat.to_param, user_id: user.id
      expect(response).to redirect_to(user_vats_path(user.id))
    end
  end
end
