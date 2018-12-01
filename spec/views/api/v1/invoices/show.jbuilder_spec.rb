# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/invoices/show/', type: :view do
  let(:valid_attributes) do
    invoice = attributes_for(:invoice)
    invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
  end

  before do
    assign(:invoice, Invoice.create(valid_attributes))
  end

  it 'Renders the requested invoice' do
    render

    invoice = JSON.parse(rendered)
    expect(invoice).to be_key('id')
    expect(invoice).to be_key('number')
    expect(invoice).to be_key('date')
    expect(invoice).to be_key('payment_method_id')
    expect(invoice).to be_key('customer_id')
    expect(invoice).to be_key('invoice_status_id')
    expect(invoice).to be_key('payment_date')
    expect(invoice).to be_key('paid_on')
    expect(invoice).to be_key('irpf')
    expect(invoice['invoice_details'].length).to eq(1)

    expect(invoice['invoice_details']).to all(be_key('id'))
    expect(invoice['invoice_details']).to all(be_key('service_id'))
    expect(invoice['invoice_details']).to all(be_key('description'))
    expect(invoice['invoice_details']).to all(be_key('quantity'))
    expect(invoice['invoice_details']).to all(be_key('price'))
    expect(invoice['invoice_details']).to all(be_key('discount'))
    expect(invoice['invoice_details']).to all(be_key('vat_rate'))
  end
end
