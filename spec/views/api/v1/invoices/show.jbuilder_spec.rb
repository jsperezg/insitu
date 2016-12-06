require 'rails_helper'

describe 'api/v1/invoices/show/', type: :view  do
  let(:valid_attributes) {
    invoice = attributes_for(:invoice)
    invoice.merge(invoice_details_attributes: [ attributes_for(:invoice_detail, invoice_id: nil) ])
  }

  before do
    assign(:invoice, Invoice.create(valid_attributes))
  end

  it 'Renders the requested invoice' do
    render

    invoice = JSON.parse(rendered)
    expect(invoice.key? 'id').to be_truthy
    expect(invoice.key? 'number').to be_truthy
    expect(invoice.key? 'date').to be_truthy
    expect(invoice.key? 'payment_method_id').to be_truthy
    expect(invoice.key? 'customer_id').to be_truthy
    expect(invoice.key? 'invoice_status_id').to be_truthy
    expect(invoice.key? 'payment_date').to be_truthy
    expect(invoice.key? 'paid_on').to be_truthy
    expect(invoice.key? 'irpf').to be_truthy
    expect(invoice['invoice_details'].length).to eq(1)

    invoice['invoice_details'].each do |detail|
      expect(detail.key? 'id').to be_truthy
      expect(detail.key? 'service_id').to be_truthy
      expect(detail.key? 'description').to be_truthy
      expect(detail.key? 'quantity').to be_truthy
      expect(detail.key? 'price').to be_truthy
      expect(detail.key? 'discount').to be_truthy
      expect(detail.key? 'vat_rate').to be_truthy
    end
  end
end