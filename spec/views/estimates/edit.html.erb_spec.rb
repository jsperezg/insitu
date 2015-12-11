require 'rails_helper'

RSpec.describe "estimates/edit", type: :view do
  before(:each) do
    @estimate = assign(:estimate, Estimate.create!())
  end

  it "renders the edit estimate form" do
    render

    assert_select "form[action=?][method=?]", estimate_path(@estimate), "post" do
    end
  end
end
