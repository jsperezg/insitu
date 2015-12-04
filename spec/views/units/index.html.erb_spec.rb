require 'rails_helper'

RSpec.describe "units/index", type: :view do
  before(:each) do
    assign(:units, [
      Unit.create!(),
      Unit.create!()
    ])
  end

  it "renders a list of units" do
    render
  end
end
