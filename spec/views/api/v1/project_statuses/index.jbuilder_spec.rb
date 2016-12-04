require 'rails_helper'

describe 'api/v1/project_statuses/index', type: :view  do
  before do
    @project_statuses = []

    2.times do |i|
      @project_statuses << ProjectStatus.create(name: "Project status #{ i }")
    end

    assign(:project_statuses, @project_statuses)
  end

  it 'Renders a list of project statuses' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "project_statuses").to be_truthy
    expect(json['project_statuses'].length).to be(2)

    json['project_statuses'].each do |status|
      expect(status.key? 'id').to be_truthy
      expect(status.key? 'name').to be_truthy

      expect(status['name']).not_to be_empty
      expect(status['id']).not_to be_nil
    end
  end
end