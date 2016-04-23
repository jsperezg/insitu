require 'rails_helper'

RSpec.describe "estimates/edit", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @estimate = assign(:estimate, create(:estimate))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit estimate form" do
    render

    assert_select "form[action=?][method=?]", user_estimate_path(@user, @estimate), "post" do
    end
  end
end
