require 'rails_helper'

RSpec.describe "delivery_note_details/show", type: :view do
  before(:each) do
    @delivery_note_detail = assign(:delivery_note_detail, DeliveryNoteDetail.create!(
      :delivery_note => nil,
      :service => nil,
      :quantity => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
