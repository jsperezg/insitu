require 'rails_helper'

describe 'api/v1/invoice_statuses/show/', type: :view  do
  before do
    assign(:invoice_status, InvoiceStatus.create(name: 'status'))
  end

  it 'Renders the requested status' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "id").to be_truthy
    expect(json.key? "name").to be_truthy
  end
end