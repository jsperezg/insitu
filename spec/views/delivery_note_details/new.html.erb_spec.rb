require 'rails_helper'

RSpec.describe "delivery_note_details/new", type: :view do
  before(:each) do
    assign(:delivery_note_detail, DeliveryNoteDetail.new(
      :delivery_note => nil,
      :service => nil,
      :quantity => "9.99"
    ))
  end

  it "renders new delivery_note_detail form" do
    render

    assert_select "form[action=?][method=?]", delivery_note_details_path, "post" do

      assert_select "input#delivery_note_detail_delivery_note_id[name=?]", "delivery_note_detail[delivery_note_id]"

      assert_select "input#delivery_note_detail_service_id[name=?]", "delivery_note_detail[service_id]"

      assert_select "input#delivery_note_detail_quantity[name=?]", "delivery_note_detail[quantity]"
    end
  end
end
