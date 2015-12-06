require 'rails_helper'

RSpec.describe Invoice, type: :model do
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

  describe 'payment date' do
  	it 'is mandatory' do
  		invoice = Invoice.new
	  	invoice.save

	  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :payment_date )}
  	end

  	it 'must be after issue date' do
  		invoice = Invoice.new(payment_date: Date.today, date: Date.today + 15.days)
  		invoice.save

	  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :payment_date )}
  	end
  end

  it 'paid on must be after issue date' do
  	invoice = Invoice.new(paid_on: Date.today, date: Date.today + 15.days)
    invoice.save

  	expect(invoice.errors).to satisfy { |errors| !errors.empty? && errors.key?( :paid_on )}
	end
end
