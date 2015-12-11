require 'rails_helper'

RSpec.describe "estimates/index", type: :view do
  before(:each) do
    assign(:estimates, [
      Estimate.create!(),
      Estimate.create!()
    ])
  end

  it "renders a list of estimates" do
    render
  end
end
