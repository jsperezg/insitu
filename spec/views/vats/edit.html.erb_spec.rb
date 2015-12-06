require 'rails_helper'

RSpec.describe "vats/edit", type: :view do
  before(:each) do
  	@user = create(:user)
    sign_in @user

    @vat = assign(:vat, create(:vat))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit vat form" do
    render

    assert_select "form[action=?][method=?]", user_vat_path(@user, @vat), "post" do
    	assert_select "input#vat_label[name=?]", "vat[label]"
      	assert_select "input#vat_rate[name=?]", "vat[rate]"
    end
  end
end
