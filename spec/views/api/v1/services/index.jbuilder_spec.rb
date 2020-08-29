# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/services/index', type: :view do
  let(:services) { create_list :service, 2 }

  before do
    assign(:services, services)
  end

  it 'Renders a list of services' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('services')
    expect(json['services'].length).to be(2)

    expect(json['services']).to all(be_key('id'))
    expect(json['services']).to all(be_key('code'))
    expect(json['services']).to all(be_key('description'))
    expect(json['services']).to all(be_key('vat'))
    expect(json['services']).to all(be_key('unit'))
    expect(json['services']).to all(be_key('price'))
  end
end
