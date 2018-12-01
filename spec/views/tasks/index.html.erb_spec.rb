# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks/index', type: :view do
  let(:user) { create :user }
  let(:project) { create :project }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:project, project)

    create_list(:task, 2, project_id: project.id)

    assign(:tasks, Task.paginate(page: 1, per_page: DEFAULT_ITEMS_PER_PAGE))
  end

  after do
    sign_out user
  end

  it 'renders a list of tasks' do
    render
  end
end
