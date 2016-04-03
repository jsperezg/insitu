require 'rails_helper'

RSpec.describe "delivery_notes/edit", type: :view do
  before(:each) do
    @user = User.first || create(:user)
    sign_in @user

    delivery_note_attrs = attributes_for :delivery_note
    delivery_note_attrs.merge(delivery_note_details_attributes: [ attributes_for(:delivery_note_detail, delivery_note_id: nil) ])

    @delivery_note = assign(:delivery_note, DeliveryNote.create!(delivery_note_attrs))
  end

  it "renders the edit delivery_note form" do
    render

    assert_select "form[action=?][method=?]", user_delivery_note_path(@user, @delivery_note), "post" do
      assert_select "input#delivery_note_number[name=?]", "delivery_note[number]"
      assert_select "input#delivery_note_customer_id[name=?]", "delivery_note[customer_id]"
    end
  end
end
