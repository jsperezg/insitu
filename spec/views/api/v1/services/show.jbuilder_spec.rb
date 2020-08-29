# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/services/show/', type: :view do
  before do
    assign(:service, create(:service))
  end

  it 'Renders the requested status' do
    render

    service = JSON.parse(rendered)
    expect(service).to be_key('id')
    expect(service).to be_key('code')
    expect(service).to be_key('description')
    expect(service).to be_key('vat')
    expect(service).to be_key('unit')
    expect(service).to be_key('price')
  end
end
