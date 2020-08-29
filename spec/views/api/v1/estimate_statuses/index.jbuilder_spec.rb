# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/estimate_statuses/index', type: :view do
  let(:estimate_statuses) { create_list :estimate_status, 2 }

  before do
    assign(:estimate_statuses, estimate_statuses)
  end

  it 'Renders a list of estimate statuses' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('estimate_statuses')
    expect(json['estimate_statuses'].length).to be(2)

    json['estimate_statuses'].each do |status|
      expect(status).to be_key('id')
      expect(status).to be_key('name')

      expect(status['name']).not_to be_empty
      expect(status['id']).not_to be_nil
    end
  end
end
