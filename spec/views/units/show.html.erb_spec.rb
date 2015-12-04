require 'rails_helper'

RSpec.describe "units/show", type: :view do
  before(:each) do
    @unit = assign(:unit, Unit.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
