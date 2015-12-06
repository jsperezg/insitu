require 'rails_helper'

RSpec.describe "customers/edit", type: :view do
  before(:each) do
  	@user = create(:user)
    sign_in @user

    @customer = assign(:customer, create(:customer))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit customer form" do
    render

    assert_select "form[action=?][method=?]", user_customer_path(@user, @customer), "post" do
    end
  end
end
