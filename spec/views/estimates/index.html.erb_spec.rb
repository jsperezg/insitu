require 'rails_helper'

RSpec.describe "estimates/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:estimates, [
      create(:estimate),
      create(:estimate)
    ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of estimates" do
    render
  end
end
