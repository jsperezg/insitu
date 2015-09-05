require 'rails_helper'

RSpec.describe "invoice_details/index", type: :view do
  before(:each) do
    assign(:invoice_details, [
      InvoiceDetail.create!(
        :invoice => nil,
        :service => nil,
        :description => "Description",
        :vat_rate => "",
        :price => "9.99"
      ),
      InvoiceDetail.create!(
        :invoice => nil,
        :service => nil,
        :description => "Description",
        :vat_rate => "",
        :price => "9.99"
      )
    ])
  end

  it "renders a list of invoice_details" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
