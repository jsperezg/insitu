# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/estimate_statuses/show/', type: :view do
  before do
    assign(:estimate_status, EstimateStatus.create(name: 'status'))
  end

  it 'Renders the requested status' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('id')
    expect(json).to be_key('name')
  end
end
