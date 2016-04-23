require 'rails_helper'

RSpec.describe "plans/edit", type: :view do
  before(:each) do
    @user = create(:admin_user)
    sign_in @user

    Thread.current[:user] = @user

    @plan = assign(:plan, create(:plan))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit plan form" do
    render

    assert_select "form[action=?][method=?]", plan_path(@plan), "post" do
    end
  end
end
