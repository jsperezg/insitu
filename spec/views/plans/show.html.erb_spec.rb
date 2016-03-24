require 'rails_helper'

RSpec.describe "plans/show", type: :view do
  before(:each) do
    @plan = assign(:plan, Plan.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
