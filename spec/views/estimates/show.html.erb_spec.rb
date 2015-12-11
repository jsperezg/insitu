require 'rails_helper'

RSpec.describe "estimates/show", type: :view do
  before(:each) do
    @estimate = assign(:estimate, Estimate.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
