require 'rails_helper'

RSpec.describe "units/new", type: :view do
  before(:each) do
    assign(:unit, Unit.new())
  end

  it "renders new unit form" do
    render

    assert_select "form[action=?][method=?]", units_path, "post" do
    end
  end
end
