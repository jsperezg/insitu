# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/edit', type: :view do
  let(:user) { create :user }
  let(:task) { create :task }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:task, task)
    assign(:project, task.project)
  end

  after do
    sign_out user
  end

  it 'renders the edit task form' do
    render

    assert_select 'form[action=?][method=?]', user_project_task_path(user, task.project, task), 'post' do
      assert_select 'textarea#task_description[name=?]', 'task[description]'

      assert_select 'input#task_project_id[name=?]', 'task[project_id]'

      assert_select 'input#task_finish_date[name=?]', 'task[finish_date]'
    end
  end
end
