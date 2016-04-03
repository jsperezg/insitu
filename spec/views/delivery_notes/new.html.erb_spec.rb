require 'rails_helper'

RSpec.describe "delivery_notes/new", type: :view do
  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    @delivery_note = assign(:delivery_note, DeliveryNote.new)
  end

  it "renders new delivery_note form" do
    render

    assert_select "form[action=?][method=?]", user_delivery_notes_path(@user), "post" do
      assert_select "input#delivery_note_customer_id[name=?]", "delivery_note[customer_id]"
    end
  end
end
