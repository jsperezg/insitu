require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    Thread.current[:user] = User.first || create(:user)
  end

  it 'date is mandatory' do
  	invoice = Invoice.new
  	invoice.save

  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :date )}
  end

  it 'payment method is mandatory' do
  	invoice = Invoice.new
  	invoice.save

  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :payment_method_id )}
  end

  it 'customer is mandatory' do
  	invoice = Invoice.new
  	invoice.save

  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :customer_id )}
  end

  it 'status is mandatory' do
  	invoice = Invoice.new
  	invoice.save

  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :invoice_status_id )}
  end

  it 'payment date is mandatory' do
    invoice = Invoice.new
    invoice.save

    expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :payment_date )}
  end

  describe 'Invoice serie' do
  	it 'generic serie' do
      customer = create(:customer, billing_serie: nil)
      invoice = create(:invoice, customer_id: customer.id)

      invoice.reload

      expect(invoice.errors.empty?).to be(true)
      expect(invoice.number).to start_with(Invoice.model_name.human[0].capitalize)
    end

    it 'custom serie' do
      customer = create(:customer, billing_serie: 'A')
      invoice = create(:invoice, customer_id: customer.id)

      invoice.reload

      expect(invoice.errors.empty?).to be(true)
      expect(invoice.number).to start_with('A')
      expect(invoice.number).to end_with('001')

      another_invoice = create(:invoice, customer_id: customer.id)

      another_invoice.reload

      expect(another_invoice.errors.empty?).to be(true)
      expect(another_invoice.number).to start_with('A')
      expect(another_invoice.number).to end_with('002')
    end
	end
end
