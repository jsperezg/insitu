require 'rails_helper'

describe 'api/v1/customers/index', type: :view  do
  before do
    @customers = []

    2.times do |i|
      @customers << create(:customer)
    end

    assign(:customers, @customers)
  end

  it 'Renders a list of customers' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "customers").to be_truthy
    expect(json['customers'].length).to be(2)

    json['customers'].each do |customer|
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
end