require 'rails_helper'

RSpec.describe "vats/show", type: :view do
  before(:each) do
    @vat = assign(:vat, Vat.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
