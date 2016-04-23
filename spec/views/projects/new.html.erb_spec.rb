require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:project, create(:project))
  end

  after(:each) do
    sign_out @user
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", user_projects_path(@user), "post" do

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "select#project_project_status_id[name=?]", "project[project_status_id]"

      assert_select "input#project_customer_id[name=?]", "project[customer_id]"
    end
  end
end
