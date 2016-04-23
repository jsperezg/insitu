require 'rails_helper'

RSpec.describe "units/new", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:unit, Unit.new)
  end

  after(:each) do
    sign_out @user
  end

  it "renders new unit form" do
    render

    assert_select "form[action=?][method=?]", user_units_path(@user), "post" do
    end
  end
end
