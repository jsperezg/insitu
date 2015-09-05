require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(
        :code => "Code",
        :description => "Description",
        :vat => nil,
        :unit => nil,
        :price => "9.99"
      ),
      Service.create!(
        :code => "Code",
        :description => "Description",
        :vat => nil,
        :unit => nil,
        :price => "9.99"
      )
    ])
  end

  it "renders a list of services" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
