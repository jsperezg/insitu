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
    vat = Vat.create(label: '21.1%', rate: 21.1)
    vat.save

    expect(vat.errors).to satisfy { |errors| !errors.empty? && errors.key?( :rate )}
  end

  describe 'default' do
    it 'just one record can by the default value' do
      vat_1 = create(:vat, default: true)
      vat_1.reload
      expect(vat_1.default).to be_truthy

      vat_2 = create(:vat, default: true)
      vat_2.reload
      expect(vat_2.default).to be_truthy

      vat_1.reload
      expect(vat_1.default).to be_falsey
    end
  end
end
