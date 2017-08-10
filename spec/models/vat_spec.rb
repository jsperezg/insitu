require 'rails_helper'

RSpec.describe Vat, type: :model do
  before(:each) do
    Thread.current[:user] = create(:user)
  end

  it 'label is required' do
    vat = Vat.create(rate: 0)
    vat.save

    expect(vat.errors).to have_key(:label)
  end

  it 'rate is required' do
    vat = Vat.create(label: '16%')
    vat.save

    expect(vat.errors).to have_key(:rate)
  end

  it 'rate is greater or equal to zero' do
    vat = Vat.create(rate: -1, label: 'wrong')
    vat.save

    expect(vat.errors).to have_key(:rate)
  end

  it 'rate is a integer number' do
    vat = Vat.new(rate: 1.1)
    vat.save

    expect(vat.errors).to have_key(:rate)
  end

  it 'rate is unique' do
    vat = Vat.create(label: '21%', rate: 21)
    expect(vat.save).to be_truthy

    other_vat = Vat.create(label: '21%', rate: 21)
    expect(other_vat.save).to be_falsey

    expect(other_vat.errors).to have_key(:rate)
  end

  describe 'default' do
    before(:each) do
      @vat21 = Vat.create(label: '21%', rate: 21, default: true)
      @vat4 = Vat.create(label: '4%', rate: 4, default: false)
    end

    it 'just one record can by the default value' do
      @vat4.default = true
      expect(@vat4.save).to be_truthy

      @vat21.reload
      expect(@vat21.default).to be_falsey
    end
  end
end
