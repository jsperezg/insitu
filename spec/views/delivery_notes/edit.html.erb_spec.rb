require 'rails_helper'

RSpec.describe "delivery_notes/edit", type: :view do
  before(:each) do
    @delivery_note = assign(:delivery_note, DeliveryNote.create!(
      :number => "MyString",
      :customer => nil
    ))
  end

  it "renders the edit delivery_note form" do
    render

    assert_select "form[action=?][method=?]", delivery_note_path(@delivery_note), "post" do

      assert_select "input#delivery_note_number[name=?]", "delivery_note[number]"

      assert_select "input#delivery_note_customer_id[name=?]", "delivery_note[customer_id]"
    end
  end
end
