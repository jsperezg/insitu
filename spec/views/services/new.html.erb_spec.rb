require 'rails_helper'

RSpec.describe "services/new", type: :view do
  before(:each) do
    assign(:service, Service.new(
      :code => "MyString",
      :description => "MyString",
      :vat => nil,
      :unit => nil,
      :price => "9.99"
    ))
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", services_path, "post" do

      assert_select "input#service_code[name=?]", "service[code]"

      assert_select "input#service_description[name=?]", "service[description]"

      assert_select "input#service_vat_id[name=?]", "service[vat_id]"

      assert_select "input#service_unit_id[name=?]", "service[unit_id]"

      assert_select "input#service_price[name=?]", "service[price]"
    end
  end
end
