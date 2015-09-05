require 'rails_helper'

RSpec.describe "delivery_note_details/index", type: :view do
  before(:each) do
    assign(:delivery_note_details, [
      DeliveryNoteDetail.create!(
        :delivery_note => nil,
        :service => nil,
        :quantity => "9.99"
      ),
      DeliveryNoteDetail.create!(
        :delivery_note => nil,
        :service => nil,
        :quantity => "9.99"
      )
    ])
  end

  it "renders a list of delivery_note_details" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
