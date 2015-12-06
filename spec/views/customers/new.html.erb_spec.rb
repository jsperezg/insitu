require 'rails_helper'

RSpec.describe "customers/new", type: :view do
  before(:each) do
  	@user = create(:user)
    sign_in @user

    assign(:customer, Customer.new)
  end

  after(:each) do
    sign_out @user
  end

  it "renders new customer form" do
    render

    assert_select "form[action=?][method=?]", user_customers_path(@user.id), "post" do
    end
  end
end
