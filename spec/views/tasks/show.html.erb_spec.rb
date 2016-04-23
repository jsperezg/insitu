require 'rails_helper'

RSpec.describe "tasks/show", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @task = assign(:task, create(:task))
    assign(:project, @task.project)
  end

  after(:each) do
    sign_out @user
  end

  it "renders attributes in <p>" do
    render
  end
end
