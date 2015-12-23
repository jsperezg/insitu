require 'rails_helper'

RSpec.describe "vats/index", type: :view do
before(:each) do
    @user = create(:user)
    sign_in @user

    @customers = []

    1.times do
      @customers << create(:vat)
    end

    assign(:customers, @customers)
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of vats" do
    render

    @customers.each do |i|
      assert_select "tr>td", :text => i[:id].to_s, :count => 1
      assert_select "tr>td", :text => i[:label], count: 1
      assert_select "tr>td", :text => i[:rate].to_s, count: 1
    end
  end
end
