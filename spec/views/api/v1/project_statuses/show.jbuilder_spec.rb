require 'rails_helper'

describe 'api/v1/project_statuses/show/', type: :view  do
  before do
    assign(:project_status, ProjectStatus.create(name: 'status'))
  end

  it 'Renders the requested status' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "id").to be_truthy
    expect(json.key? "name").to be_truthy
  end
end