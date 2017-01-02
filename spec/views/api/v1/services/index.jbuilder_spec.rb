require 'rails_helper'

describe 'api/v1/services/index', type: :view  do
  before do
    @services = []

    2.times do |i|
      @services << create(:service)
    end

    assign(:services, @services)
  end

  it 'Renders a list of services' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "services").to be_truthy
    expect(json['services'].length).to be(2)

    json['services'].each do |service|
      expect(service.key? 'id').to be_truthy
      expect(service.key? 'code').to be_truthy
      expect(service.key? 'description').to be_truthy
      expect(service.key? 'vat').to be_truthy
      expect(service.key? 'unit').to be_truthy
      expect(service.key? 'price').to be_truthy
    end
  end
end