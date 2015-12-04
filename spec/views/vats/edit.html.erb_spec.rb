require 'rails_helper'

RSpec.describe "vats/edit", type: :view do
  before(:each) do
    @vat = assign(:vat, Vat.create!())
  end

  it "renders the edit vat form" do
    render

    assert_select "form[action=?][method=?]", vat_path(@vat), "post" do
    end
  end
end
