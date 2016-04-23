require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:projects, [
      create(:project),
      create(:project)
    ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of projects" do
    render
  end
end
