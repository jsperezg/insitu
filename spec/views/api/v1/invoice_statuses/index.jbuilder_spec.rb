require 'rails_helper'

describe 'api/v1/invoice_statuses/index', type: :view  do
  before do
    @invoice_statuses = []

    2.times do |i|
      @invoice_statuses << InvoiceStatus.create(name: "Invoice status #{ i }")
    end

    assign(:invoice_statuses, @invoice_statuses)
  end

  it 'Renders a list of invoice statuses' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "invoice_statuses").to be_truthy
    expect(json['invoice_statuses'].length).to be(2)

    json['invoice_statuses'].each do |status|
      expect(status.key? 'id').to be_truthy
      expect(status.key? 'name').to be_truthy

      expect(status['name']).not_to be_empty
      expect(status['id']).not_to be_nil
    end
  end
end