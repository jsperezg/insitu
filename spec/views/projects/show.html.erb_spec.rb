require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @project = assign(:project, create(:project))
  end

  after(:each) do
    sign_out @user
  end

  it "renders attributes in <p>" do
    render
  end
end
