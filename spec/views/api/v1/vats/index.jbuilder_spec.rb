require 'rails_helper'

describe 'api/v1/vats/index', type: :view  do
  before do
    @vats = []

    2.times do |i|
      @vats << create(:vat)
    end

    assign(:vat, @vats)
  end

  it 'Renders a list of vats' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "vats").to be_truthy
    expect(json['vats'].length).to be(2)

    json['vats'].each do |vat|
      expect(vat.key? 'id').to be_truthy
      expect(vat.key? 'label').to be_truthy
      expect(vat.key? 'rate').to be_truthy
      expect(vat.key? 'default').to be_truthy
    end
  end
end