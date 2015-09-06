require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'name is mandatory' do
    customer = Customer.new
    customer.save

    expect(customer.errors).to satisfy { |errors| !errors.empty? && errors.key?( :name )}
  end

  it 'email is not mandatory' do
    customer = Customer.new(name: 'One customer', contact_email: '')
    customer.save

    expect(customer.errors).to satisfy { |errors| errors.empty? }
  end

  it 'email must be valid' do
    customer = Customer.new(name: 'Another customer', contact_email: 'bwaaa')
    customer.save

    expect(customer.errors).to satisfy { |errors| !errors.empty? && errors.key?( :contact_email )}
  end

  it 'tax id accepts blanks' do
    Customer.create(name: 'One customer', tax_id: '')

    customer = Customer.new(name: 'another customer', tax_id: '')
    customer.save

    expect(customer.errors).to satisfy { |errors| errors.empty? }
  end

  it 'tax id do not accept duplicates' do
    Customer.create!(name: 'One customer', tax_id: '1234')

    customer = Customer.new(name: 'another customer', tax_id: '1234')
    customer.save
    
    expect(customer.errors).to satisfy { |errors| !errors.empty? && errors.key?( :tax_id )}
  end
end
