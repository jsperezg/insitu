require 'rails_helper'

RSpec.describe "payment_methods/edit", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    @payment_method = assign(:payment_method, create(:payment_method))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit payment_method form" do
    render

    assert_select "form[action=?][method=?]", user_payment_method_path(@user, @payment_method), "post" do
      assert_select "input#payment_method_name[name=?]", "payment_method[name]"
      assert_select "select#payment_method_note_for_invoice[name=?]", "payment_method[note_for_invoice]"
    end
  end
end
