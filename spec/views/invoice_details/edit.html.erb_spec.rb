require 'rails_helper'

RSpec.describe "invoice_details/edit", type: :view do
  before(:each) do
    @invoice_detail = assign(:invoice_detail, InvoiceDetail.create!(
      :invoice => nil,
      :service => nil,
      :description => "MyString",
      :vat_rate => "",
      :price => "9.99"
    ))
  end

  it "renders the edit invoice_detail form" do
    render

    assert_select "form[action=?][method=?]", invoice_detail_path(@invoice_detail), "post" do

      assert_select "input#invoice_detail_invoice_id[name=?]", "invoice_detail[invoice_id]"

      assert_select "input#invoice_detail_service_id[name=?]", "invoice_detail[service_id]"

      assert_select "input#invoice_detail_description[name=?]", "invoice_detail[description]"

      assert_select "input#invoice_detail_vat_rate[name=?]", "invoice_detail[vat_rate]"

      assert_select "input#invoice_detail_price[name=?]", "invoice_detail[price]"
    end
  end
end
