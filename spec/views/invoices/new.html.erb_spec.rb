require 'rails_helper'

RSpec.describe "invoices/new", type: :view do
  before(:each) do
    assign(:invoice, Invoice.new(
      :number => "MyString",
      :payment_method => nil,
      :customer => nil
    ))
  end

  it "renders new invoice form" do
    render

    assert_select "form[action=?][method=?]", invoices_path, "post" do

      assert_select "input#invoice_number[name=?]", "invoice[number]"

      assert_select "input#invoice_payment_method_id[name=?]", "invoice[payment_method_id]"

      assert_select "input#invoice_customer_id[name=?]", "invoice[customer_id]"
    end
  end
end
