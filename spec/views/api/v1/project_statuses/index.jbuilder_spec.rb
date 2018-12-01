# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/project_statuses/index', type: :view do
  let(:project_statuses) { create_list :project_status, 2 }

  before do
    assign(:project_statuses, project_statuses)
  end

  it 'Renders a list of project statuses' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('project_statuses')
    expect(json['project_statuses'].length).to be(2)

    json['project_statuses'].each do |status|
      expect(status).to be_key('id')
      expect(status).to be_key('name')

      expect(status['name']).not_to be_empty
      expect(status['id']).not_to be_nil
    end
  end
end
