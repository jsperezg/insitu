# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { create(:user, password: 'Abcd1234', password_confirmation: 'Abcd1234') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'login' do
    post :create, format: :json, session: { email: user.email, password: 'Abcd1234' }
    expect(response.status).to eq(200)
    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response[:id]).to eq(user.id)
    expect(json_response[:email]).to eq(user.email)
    expect(json_response[:authentication_token]).not_to be_blank
  end

  it 'logout' do
    post :create, format: :json, session: { email: user.email, password: 'Abcd1234' }
    expect(response.status).to eq(200)

    sign_in user

    current_token = user.authentication_token

    delete :destroy, user_token: user.authentication_token
    expect(response.status).to eq(200)

    user.reload
    expect(user.authentication_token).not_to eq(current_token)
  end
end
