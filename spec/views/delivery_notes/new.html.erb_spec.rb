require 'rails_helper'

RSpec.describe "delivery_notes/new", type: :view do
  before(:each) do
    assign(:delivery_note, DeliveryNote.new(
      :number => "MyString",
      :customer => nil
    ))
  end

  it "renders new delivery_note form" do
    render

    assert_select "form[action=?][method=?]", delivery_notes_path, "post" do

      assert_select "input#delivery_note_number[name=?]", "delivery_note[number]"

      assert_select "input#delivery_note_customer_id[name=?]", "delivery_note[customer_id]"
    end
  end
end
