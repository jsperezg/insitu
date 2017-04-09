require 'rails-controller-testing'
require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = create(:user,  password: 'Abcd1234', password_confirmation: 'Abcd1234')
  end

  it 'login' do
    post :create, params: { format: :json, session: { email: @user.email, password: 'Abcd1234'} }
    expect(response.status).to eq(200)
    json_response = JSON.parse(response.body, {:symbolize_names => true})
    expect(json_response[:id]).to eq(@user.id)
    expect(json_response[:email]).to eq(@user.email)
    expect(json_response[:authentication_token].blank?).not_to be_truthy
  end

  it  'logout' do
    post :create, params: { format: :json, session: { email: @user.email, password: 'Abcd1234'} }
    expect(response.status).to eq(200)

    sign_in @user

    current_token = @user.authentication_token

    delete :destroy, user_token: @user.authentication_token
    expect(response.status).to eq(200)

    @user.reload
    expect(@user.authentication_token).not_to eq(current_token)
  end
end