require 'rails_helper'

RSpec.describe "payment_methods/new", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:payment_method, create(:payment_method))
  end

  after(:each) do
    sign_out @user
  end

  it "renders new payment_method form" do
    render

    assert_select "form[action=?][method=?]", user_payment_methods_path(@user.id), "post" do
      assert_select "input#payment_method_name[name=?]", "payment_method[name]"
      assert_select "textarea#payment_method_note_for_invoice[name=?]", "payment_method[note_for_invoice]"
    end
  end
end
