# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { User.first || create(:user) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'Return totals for past year' do
      get :index, params: { user_id: user.id }
      expect(assigns(:reports)).to be_key(:past_year)
    end

    it 'Return totals for current year' do
      get :index, params: { user_id: user.id }
      expect(assigns(:reports)).to be_key(:current_year)
    end

    it 'Return totals for current month' do
      get :index, params: { user_id: user.id }
      expect(assigns(:reports)).to be_key(:current_month)
    end

    it 'Return totals for last year' do
      get :index, params: { user_id: user.id }
      expect(assigns(:reports)).to be_key(:last_year)
    end
  end
end
