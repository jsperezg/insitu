require 'rails_helper'

RSpec.describe "estimates/new", type: :view do
  before(:each) do
    assign(:estimate, Estimate.new())
  end

  it "renders new estimate form" do
    render

    assert_select "form[action=?][method=?]", estimates_path, "post" do
    end
  end
end
