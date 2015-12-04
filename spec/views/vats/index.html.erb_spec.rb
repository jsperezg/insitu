require 'rails_helper'

RSpec.describe "vats/index", type: :view do
  before(:each) do
    assign(:vats, [
      Vat.create!(),
      Vat.create!()
    ])
  end

  it "renders a list of vats" do
    render
  end
end
