# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/units/index', type: :view do
  let(:units) { create_list :unit, 2 }

  before do
    assign(:units, units)
  end

  it 'Renders a list of units' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('units')
    expect(json['units'].length).to be(2)

    expect(json['units']).to all(be_key('id'))
    expect(json['units']).to all(be_key('label_short'))
    expect(json['units']).to all(be_key('label_long'))
  end
end
