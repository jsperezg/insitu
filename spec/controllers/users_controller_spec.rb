# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { attributes_for :user, :admin }

  let(:invalid_attributes) do
    {
      role_id: Role.find_by(description: 'Administrator')&.id || create(:admin_role)&.id,
      valid_until: nil
    }
  end

  let(:user) { create(:user, :admin) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all users as users' do
      user = User.create! valid_attributes
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user as user' do
      user = User.create! valid_attributes
      get :edit, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          valid_until: Date.today + 365.days,
          role_id: Role.find_by(description: 'User').try(:id) || create(:role).try(:id)
        }
      end

      it 'updates the requested user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload

        expect(user[:role_id]).to eq(new_attributes[:role_id])
        expect(user[:valid_until]).to eq(new_attributes[:valid_until])
      end

      it 'assigns the requested user as user' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the users list' do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to redirect_to(users_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the user as user' do
        user = create(:user, banned: true)
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = create(:user, banned: true)
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #ban' do
    it 'bans the requested user' do
      user = create(:user)

      delete :ban, params: { id: user.to_param }

      user.reload
      expect(user.banned).to be_truthy
    end

    it 'redirects to the users list' do
      user = create(:user)

      delete :ban, params: { id: user.to_param }
      expect(response).to redirect_to(users_path)
    end
  end
end
