require 'rails_helper'

RSpec.describe "invoices/new", type: :view do
  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    assign(:invoice, Invoice.new(
      date: Date.today,
      :payment_method => nil,
      :customer => nil
    ))
  end

  it "renders new invoice form" do
    render

    assert_select "form[action=?][method=?]", user_invoices_path(@user), "post" do
      assert_select "select#invoice_payment_method_id[name=?]", "invoice[payment_method_id]"
    end
  end
end
