# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/customers/show/', type: :view do
  before do
    assign(:customer, create(:customer))
  end

  it 'Renders the requested status' do
    render

    customer = JSON.parse(rendered)
    expect(customer).to be_key('id')
    expect(customer).to be_key('name')
    expect(customer).to be_key('tax_id')
    expect(customer).to be_key('billing_serie')
    expect(customer).to be_key('irpf')
    expect(customer).to be_key('contact_name')
    expect(customer).to be_key('contact_phone')
    expect(customer).to be_key('contact_email')
    expect(customer).to be_key('address')
    expect(customer).to be_key('city')
    expect(customer).to be_key('postal_code')
    expect(customer).to be_key('state')
    expect(customer).to be_key('country')
    expect(customer).to be_key('send_invoices_to')
  end
end
