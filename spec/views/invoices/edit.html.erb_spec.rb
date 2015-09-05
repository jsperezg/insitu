require 'rails_helper'

RSpec.describe "invoices/edit", type: :view do
  before(:each) do
    @invoice = assign(:invoice, Invoice.create!(
      :number => "MyString",
      :payment_method => nil,
      :customer => nil
    ))
  end

  it "renders the edit invoice form" do
    render

    assert_select "form[action=?][method=?]", invoice_path(@invoice), "post" do

      assert_select "input#invoice_number[name=?]", "invoice[number]"

      assert_select "input#invoice_payment_method_id[name=?]", "invoice[payment_method_id]"

      assert_select "input#invoice_customer_id[name=?]", "invoice[customer_id]"
    end
  end
end
