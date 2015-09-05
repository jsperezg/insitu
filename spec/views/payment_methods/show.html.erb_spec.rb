require 'rails_helper'

RSpec.describe "payment_methods/show", type: :view do
  before(:each) do
    @payment_method = assign(:payment_method, PaymentMethod.create!(
      :name => "Name",
      :note_for_invoice => "Note For Invoice"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Note For Invoice/)
  end
end
