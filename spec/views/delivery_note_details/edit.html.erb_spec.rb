require 'rails_helper'

RSpec.describe "delivery_note_details/edit", type: :view do
  before(:each) do
    @delivery_note_detail = assign(:delivery_note_detail, DeliveryNoteDetail.create!(
      :delivery_note => nil,
      :service => nil,
      :quantity => "9.99"
    ))
  end

  it "renders the edit delivery_note_detail form" do
    render

    assert_select "form[action=?][method=?]", delivery_note_detail_path(@delivery_note_detail), "post" do

      assert_select "input#delivery_note_detail_delivery_note_id[name=?]", "delivery_note_detail[delivery_note_id]"

      assert_select "input#delivery_note_detail_service_id[name=?]", "delivery_note_detail[service_id]"

      assert_select "input#delivery_note_detail_quantity[name=?]", "delivery_note_detail[quantity]"
    end
  end
end
