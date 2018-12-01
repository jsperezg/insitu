# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  let(:user) { create :user }
  let(:project) { create :project }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:project, project)
  end

  after do
    sign_out user
  end

  it 'renders the edit project form' do
    render

    assert_select 'form[action=?][method=?]', user_project_path(user, project), 'post' do
      assert_select 'input#project_name[name=?]', 'project[name]'
      assert_select 'select#project_project_status_id[name=?]', 'project[project_status_id]'
      assert_select 'input#project_customer_id[name=?]', 'project[customer_id]'
    end
  end
end
