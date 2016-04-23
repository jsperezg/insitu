require 'rails_helper'

RSpec.describe "plans/index", type: :view do
  before(:each) do
    @user = create(:admin_user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:plans, [
      create(:plan),
      create(:plan)
    ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of plans" do
    render
  end
end
