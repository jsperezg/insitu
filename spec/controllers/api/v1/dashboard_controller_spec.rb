require 'rails_helper'

RSpec.describe Api::V1::DashboardController, type: :controller do
  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    Thread.current[:user] = @user
  end

  after(:each) do
    sign_out @user
  end

  describe "GET #index" do
    it "Return totals for four periods" do
      get :index, {user_id: @user.id, format: :json }
      expect(assigns(:reports).key?(:past_year)).to be_truthy
      expect(assigns(:reports).key?(:current_year)).to be_truthy
      expect(assigns(:reports).key?(:current_month)).to be_truthy
      expect(assigns(:reports).key?(:last_year)).to be_truthy
    end
  end
end