require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(
      :description => "MyString",
      :project => nil,
      :finished => false
    ))
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do

      assert_select "input#task_description[name=?]", "task[description]"

      assert_select "input#task_project_id[name=?]", "task[project_id]"

      assert_select "input#task_finished[name=?]", "task[finished]"
    end
  end
end
