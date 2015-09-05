require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    assign(:task, Task.new(
      :description => "MyString",
      :project => nil,
      :finished => false
    ))
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", tasks_path, "post" do

      assert_select "input#task_description[name=?]", "task[description]"

      assert_select "input#task_project_id[name=?]", "task[project_id]"

      assert_select "input#task_finished[name=?]", "task[finished]"
    end
  end
end
