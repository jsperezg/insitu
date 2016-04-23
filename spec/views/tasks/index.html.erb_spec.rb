require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  before(:each) do
    @user = create(:user)
    sign_in @user

    Thread.current[:user] = @user

    @project = assign(:project, create(:project))

    2.times do
      create(:task, project_id: @project.id)
    end

    assign(:tasks, Task.paginate(page: 1, per_page: DEFAULT_ITEMS_PER_PAGE))
  end

  after(:each) do
    sign_out @user
  end

  it "renders a list of tasks" do
    render
  end
end
