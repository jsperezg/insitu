require 'rails_helper'

RSpec.describe "units/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:units, [
      create(:unit),
      create(:unit)
    ])
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of units" do
    render
  end
end
