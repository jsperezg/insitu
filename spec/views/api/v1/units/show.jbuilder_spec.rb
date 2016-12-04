require 'rails_helper'

describe 'api/v1/units/show/', type: :view  do
  before do
    assign(:unit, create(:unit))
  end

  it 'Renders the requested status' do
    render

    unit = JSON.parse(rendered)
    expect(unit.key? 'id').to be_truthy
    expect(unit.key? 'label_short').to be_truthy
    expect(unit.key? 'label_long').to be_truthy
  end
end