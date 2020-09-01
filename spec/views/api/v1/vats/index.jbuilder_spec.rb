# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/vats/index', type: :view do
  let(:vats) { create_list(:vat, 5) }

  before do
    assign(:vats, vats)
  end

  it 'Renders a list of vats' do
    render

    json = JSON.parse(rendered)
    expect(json).to have_key('vats')
    expect(json['vats']).not_to be_empty
    expect(json['vats'].length).to be(vats.length)

    expect(json['vats']).to all(have_key('id'))
    expect(json['vats']).to all(have_key('rate'))
    expect(json['vats']).to all(have_key('default'))
  end
end
