require 'rails_helper'

RSpec.describe "invoice_details/show", type: :view do
  before(:each) do
    @invoice_detail = assign(:invoice_detail, InvoiceDetail.create!(
      :invoice => nil,
      :service => nil,
      :description => "Description",
      :vat_rate => "",
      :price => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
