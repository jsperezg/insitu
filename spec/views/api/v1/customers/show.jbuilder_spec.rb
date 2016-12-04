require 'rails_helper'

describe 'api/v1/customers/show/', type: :view  do
  before do
    assign(:customer, create(:customer))
  end

  it 'Renders the requested status' do
    render

    customer = JSON.parse(rendered)
    expect(customer.key? 'id').to be_truthy
    expect(customer.key? 'name').to be_truthy
    expect(customer.key? 'tax_id').to be_truthy
    expect(customer.key? 'billing_serie').to be_truthy
    expect(customer.key? 'irpf').to be_truthy
    expect(customer.key? 'contact_name').to be_truthy
    expect(customer.key? 'contact_phone').to be_truthy
    expect(customer.key? 'contact_email').to be_truthy
    expect(customer.key? 'address').to be_truthy
    expect(customer.key? 'city').to be_truthy
    expect(customer.key? 'postal_code').to be_truthy
    expect(customer.key? 'state').to be_truthy
    expect(customer.key? 'country').to be_truthy
    expect(customer.key? 'send_invoices_to').to be_truthy
  end
end