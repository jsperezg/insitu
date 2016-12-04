require 'rails_helper'

describe 'api/v1/vats/show/', type: :view  do
  before do
    assign(:vat, create(:vat))
  end

  it 'Renders the requested vat' do
    render

    vat = JSON.parse(rendered)
    expect(vat.key? 'id').to be_truthy
    expect(vat.key? 'label').to be_truthy
    expect(vat.key? 'rate').to be_truthy
    expect(vat.key? 'default').to be_truthy
  end
end