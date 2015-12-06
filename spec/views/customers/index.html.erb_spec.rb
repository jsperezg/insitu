require 'rails_helper'

RSpec.describe "customers/index", type: :view do
  before(:each) do   
  	@user = create(:user)
    sign_in @user

    assign(:customers, [
      create(:customer),
      create(:customer)
    ])
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of customers" do
    render
  end
end
