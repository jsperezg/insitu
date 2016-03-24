require 'rails_helper'

RSpec.describe "plans/index", type: :view do
  before(:each) do
    assign(:plans, [
      Plan.create!(),
      Plan.create!()
    ])
  end

  it "renders a list of plans" do
    render
  end
end
