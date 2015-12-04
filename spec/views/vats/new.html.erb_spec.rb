require 'rails_helper'

RSpec.describe "vats/new", type: :view do
  before(:each) do
    assign(:vat, Vat.new())
  end

  it "renders new vat form" do
    render

    assert_select "form[action=?][method=?]", vats_path, "post" do
    end
  end
end
