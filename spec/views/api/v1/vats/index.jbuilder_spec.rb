# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/vats/index', type: :view do
  let(:vats) { create_list(:vat, 2) }

  before do
    assign(:vats, vats)
  end

  it 'Renders a list of vats' do
    render

    json = JSON.parse(rendered)
    expect(json).to have_key('vats')
    expect(json['vats'].length).to be(vats.length)

    json['vats'].each do |vat|
      expect(vat).to have_key('id')
      expect(vat).to have_key('rate')
      expect(vat).to have_key('default')
    end
  end
end