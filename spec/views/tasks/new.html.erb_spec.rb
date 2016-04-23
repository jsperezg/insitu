require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    assign(:task, Task.new)
    @project = assign(:project, create(:project))
  end

  after(:each) do
    sign_out @user
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", user_project_tasks_path(@user.to_param, @project.to_param), "post" do

      assert_select "textarea#task_description[name=?]", "task[description]"

      assert_select "input#task_project_id[name=?]", "task[project_id]"

      assert_select "input#task_finish_date[name=?]", "task[finish_date]"
    end
  end
end
