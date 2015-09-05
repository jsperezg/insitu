require 'rails_helper'

RSpec.describe "delivery_notes/show", type: :view do
  before(:each) do
    @delivery_note = assign(:delivery_note, DeliveryNote.create!(
      :number => "Number",
      :customer => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number/)
    expect(rendered).to match(//)
  end
end
