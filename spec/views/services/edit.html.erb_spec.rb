require 'rails_helper'

RSpec.describe "services/edit", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @service = assign(:service, create(:service))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit service form" do
    render

    assert_select "form[action=?][method=?]", user_service_path(@user, @service), "post" do

      assert_select "input#service_code[name=?]", "service[code]"

      assert_select "input#service_description[name=?]", "service[description]"

      assert_select "select#service_vat_id[name=?]", "service[vat_id]"

      assert_select "select#service_unit_id[name=?]", "service[unit_id]"

      assert_select "input#service_price[name=?]", "service[price]"
    end
  end
end
