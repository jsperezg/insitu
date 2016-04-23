require 'rails_helper'

RSpec.describe "payment_methods/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    @payment_methods = []

    2.times do
      @payment_methods << create(:payment_method)
    end

    assign(:payment_methods, @payment_methods)    
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of payment_methods" do
    render

    @payment_methods.each do |i|
      assert_select "tr>td", :text => i[:name], count: 1
    end
  end
end
