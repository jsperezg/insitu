require 'rails_helper'

RSpec.describe "services/edit", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      :code => "MyString",
      :description => "MyString",
      :vat => nil,
      :unit => nil,
      :price => "9.99"
    ))
  end

  it "renders the edit service form" do
    render

    assert_select "form[action=?][method=?]", service_path(@service), "post" do

      assert_select "input#service_code[name=?]", "service[code]"

      assert_select "input#service_description[name=?]", "service[description]"

      assert_select "input#service_vat_id[name=?]", "service[vat_id]"

      assert_select "input#service_unit_id[name=?]", "service[unit_id]"

      assert_select "input#service_price[name=?]", "service[price]"
    end
  end
end
