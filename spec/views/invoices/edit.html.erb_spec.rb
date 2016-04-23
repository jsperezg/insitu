require 'rails_helper'

RSpec.describe "invoices/edit", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user
    @invoice = assign(:invoice, create(:invoice))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit invoice form" do
    render

    assert_select "form[action=?][method=?]", user_invoice_path(@user,@invoice), "post" do

      assert_select "input#invoice_number[name=?]", "invoice[number]"

      assert_select "select#invoice_payment_method_id[name=?]", "invoice[payment_method_id]"

      assert_select "input#invoice_customer_id[name=?]", "invoice[customer_id]"
    end
  end
end
