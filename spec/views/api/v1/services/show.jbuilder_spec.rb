require 'rails_helper'

describe 'api/v1/services/show/', type: :view  do
  before do
    assign(:service, create(:service))
  end

  it 'Renders the requested status' do
    render

    service = JSON.parse(rendered)
    expect(service.key? 'id').to be_truthy
    expect(service.key? 'code').to be_truthy
    expect(service.key? 'description').to be_truthy
    expect(service.key? 'vat').to be_truthy
    expect(service.key? 'unit').to be_truthy
    expect(service.key? 'price').to be_truthy
  end
end