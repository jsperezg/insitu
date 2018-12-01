# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/units/show/', type: :view do
  before do
    assign(:unit, create(:unit))
  end

  it 'Renders the requested status' do
    render

    unit = JSON.parse(rendered)
    expect(unit).to be_key('id')
    expect(unit).to be_key('label_short')
    expect(unit).to be_key('label_long')
  end
end
