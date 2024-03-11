# frozen_string_literal: true

require 'rails_helper'

describe Customer, type: :model do
  before do
    Thread.current[:user] = create(:user)
  end

  it 'name is mandatory' do
    customer = described_class.new
    customer.save

    expect(customer.errors).to be_key :name
  end

  it 'email is not mandatory' do
    customer = described_class.new(name: 'One customer', contact_email: '')
    customer.save

    expect(customer.errors).to satisfy(&:empty?)
  end

  it 'email must be valid' do
    customer = described_class.new(name: 'Another customer', contact_email: 'bwaaa')
    customer.save

    expect(customer.errors).to be_key :contact_email
  end

  it 'tax id accepts blanks' do
    described_class.create(name: 'One customer', tax_id: '')

    customer = described_class.new(name: 'another customer', tax_id: '')
    customer.save

    expect(customer.errors).to satisfy(&:empty?)
  end

  it 'tax id do not accept duplicates' do
    described_class.create!(name: 'One customer', tax_id: '1234')

    customer = described_class.new(name: 'another customer', tax_id: '1234')
    customer.save

    expect(customer.errors).to be_key :tax_id
  end

  it 'irpf must be a number' do
    c = described_class.new(irpf: 'asdfasdfasdf')
    c.save

    expect(c.errors).to be_key :irpf
  end

  it 'irpf must be an integer' do
    c = described_class.new(irpf: 1.2)
    c.save

    expect(c.errors).to be_key :irpf
  end

  it 'irpf must be great or equal to zero' do
    c = described_class.new(irpf: -1)
    c.save

    expect(c.errors).to be_key :irpf
  end
end
