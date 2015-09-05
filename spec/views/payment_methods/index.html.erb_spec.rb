require 'rails_helper'

RSpec.describe "payment_methods/index", type: :view do
  before(:each) do
    assign(:payment_methods, [
      PaymentMethod.create!(
        :name => "Name",
        :note_for_invoice => "Note For Invoice"
      ),
      PaymentMethod.create!(
        :name => "Name",
        :note_for_invoice => "Note For Invoice"
      )
    ])
  end

  it "renders a list of payment_methods" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Note For Invoice".to_s, :count => 2
  end
end
