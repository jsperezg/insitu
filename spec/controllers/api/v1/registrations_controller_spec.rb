# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  let(:email) { Faker::Internet.email }
  let(:user) do
    {
      email: email,
      password: 'Abcd1234',
      password_confirmation: 'Abcd1234',
      terms_and_conditions: true
    }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'allows user registration without confirmation required' do
    post :create, format: :json, user: user
    expect(response.status).to eq(200)

    user = User.find_by(email: email)
    expect(user).not_to be_nil
    expect(user.confirmed_at).not_to be_nil
  end

  it 'returns user attributes after registration' do
    post :create, format: :json, user: user
    expect(response.status).to eq(200)

    user = User.find_by(email: email)
    expect(user).not_to be_nil

    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response[:data][:user][:id]).to eq(user.id)
    expect(json_response[:data][:user][:email]).to eq(user.email)
  end
end
