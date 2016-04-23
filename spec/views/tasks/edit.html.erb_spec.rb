require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
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

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", user_project_task_path(@user, @task.project, @task), "post" do

      assert_select "textarea#task_description[name=?]", "task[description]"

      assert_select "input#task_project_id[name=?]", "task[project_id]"

      assert_select "input#task_finish_date[name=?]", "task[finish_date]"
    end
  end
end
