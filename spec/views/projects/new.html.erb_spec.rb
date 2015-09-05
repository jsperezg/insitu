require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    assign(:project, Project.new(
      :name => "MyString",
      :project_status => nil,
      :customer => nil
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "input#project_project_status_id[name=?]", "project[project_status_id]"

      assert_select "input#project_customer_id[name=?]", "project[customer_id]"
    end
  end
end
