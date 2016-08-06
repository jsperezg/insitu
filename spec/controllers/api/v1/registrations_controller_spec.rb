require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'allows user registration without confirmation required' do
    email = Faker::Internet.email

    post :create, format: :json, user: { email: email, password: 'Abcd1234', password_confirmation: 'Abcd1234'}
    expect(response.status).to eq(200)

    user = User.find_by(email: email)
    expect(user).not_to  be_nil
    expect(user.confirmed_at).not_to be_nil
  end
end