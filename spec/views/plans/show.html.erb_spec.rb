require 'rails_helper'

RSpec.describe "plans/show", type: :view do
  before(:each) do
    @user = create(:admin_user)
    sign_in @user

    Thread.current[:user] = @user

    @plan = assign(:plan, create(:project))
  end

  after(:each) do
    sign_out @user
  end

  it "renders attributes in <p>" do
    render
  end
end
