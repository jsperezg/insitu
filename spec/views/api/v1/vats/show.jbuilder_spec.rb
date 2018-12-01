# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/vats/show/', type: :view do
  let(:vat) { Vat.first || create(:vat) }

  before do
    assign(:vat, vat)
  end

  it 'Renders the requested vat' do
    render

    vat = JSON.parse(rendered)
    expect(vat).to have_key('id')
    expect(vat).to have_key('rate')
    expect(vat).to have_key('default')
  end
end
