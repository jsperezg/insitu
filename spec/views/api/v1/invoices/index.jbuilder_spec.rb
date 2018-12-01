# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/invoices/index', type: :view do
  let(:valid_attributes) do
    invoice = attributes_for(:invoice)

    invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
  end

  before do
    invoices = []
    invoices << Invoice.create(valid_attributes)

    assign(:invoices, invoices)
  end

  it 'Renders a list of Invoices' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('invoices')
    expect(json['invoices'].length).to eq(1)

    json['invoices'].each do |invoice|
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
end
