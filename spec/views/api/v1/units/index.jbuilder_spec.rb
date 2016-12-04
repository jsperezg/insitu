require 'rails_helper'

describe 'api/v1/units/index', type: :view  do
  before do
    @units = []

    2.times do |i|
      @units << create(:unit)
    end

    assign(:unit, @units)
  end

  it 'Renders a list of units' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "units").to be_truthy
    expect(json['units'].length).to be(2)

    json['units'].each do |unit|
      expect(unit.key? 'id').to be_truthy
      expect(unit.key? 'label_short').to be_truthy
      expect(unit.key? 'label_long').to be_truthy
    end
  end
end