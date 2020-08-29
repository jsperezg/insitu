# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/customers/index', type: :view do
  let(:customers) { create_list :customer, 2 }

  before do
    assign(:customers, customers)
  end

  it 'Renders a list of customers' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('customers')
    expect(json['customers'].length).to be(2)

    expect(json['customers']).to all(be_key('id'))
    expect(json['customers']).to all(be_key('name'))
    expect(json['customers']).to all(be_key('tax_id'))
    expect(json['customers']).to all(be_key('billing_serie'))
    expect(json['customers']).to all(be_key('irpf'))
    expect(json['customers']).to all(be_key('contact_name'))
    expect(json['customers']).to all(be_key('contact_phone'))
    expect(json['customers']).to all(be_key('contact_email'))
    expect(json['customers']).to all(be_key('address'))
    expect(json['customers']).to all(be_key('city'))
    expect(json['customers']).to all(be_key('postal_code'))
    expect(json['customers']).to all(be_key('state'))
    expect(json['customers']).to all(be_key('country'))
    expect(json['customers']).to all(be_key('send_invoices_to'))
  end
end
