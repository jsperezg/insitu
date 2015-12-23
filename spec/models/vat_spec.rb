require 'rails_helper'

RSpec.describe Vat, type: :model do
  it 'label is required' do
  	vat = Vat.create(rate: 0)
  	vat.save

  	expect(vat.errors).to satisfy { |errors| !errors.empty? && errors.key?( :label )}
  end

  it 'rate is required' do
  	vat = Vat.create(label: '16%')
  	vat.save

  	expect(vat.errors).to satisfy { |errors| !errors.empty? && errors.key?( :rate )}
  end

  it 'rate is greater or equal to zero' do
  	vat = Vat.create(rate: -1, label: 'wrong')
  	vat.save

  	expect(vat.errors).to satisfy { |errors| !errors.empty? && errors.key?( :rate )}
  end

  it 'rate is a integer number' do
    vat = Vat.new(rate: 1.1)
    vat.save

    expect(vat.errors).to satisfy { |errors| !errors.empty? && errors.key?( :rate )}
  end

  it 'rate is unique' do
    vat = Vat.create(label: '21%', rate: 21)
    vat.save

    expect(vat.errors).to satisfy { |errors| !errors.empty? && errors.key?( :rate )}
  end
end
