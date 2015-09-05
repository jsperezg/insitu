require 'rails_helper'

RSpec.describe "delivery_notes/index", type: :view do
  before(:each) do
    assign(:delivery_notes, [
      DeliveryNote.create!(
        :number => "Number",
        :customer => nil
      ),
      DeliveryNote.create!(
        :number => "Number",
        :customer => nil
      )
    ])
  end

  it "renders a list of delivery_notes" do
    render
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
