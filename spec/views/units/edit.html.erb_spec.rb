require 'rails_helper'

RSpec.describe "units/edit", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @unit = assign(:unit, create(:unit))
  end

  after(:each) do
    sign_out @user
  end

  it "renders the edit unit form" do
    render

    assert_select "form[action=?][method=?]", user_unit_path(@user, @unit), "post" do
    end
  end
end
