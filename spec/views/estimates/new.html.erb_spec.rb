require 'rails_helper'

RSpec.describe "estimates/new", type: :view do
  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    assign(:estimate, Estimate.new)
  end

  it "renders new estimate form" do
    render

    assert_select "form[action=?][method=?]", user_estimates_path(@user), "post" do
    end
  end
end
