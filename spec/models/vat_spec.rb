# frozen_string_literal: true

require 'rails_helper'

describe Vat, type: :model do
  it 'rate is required' do
    vat = described_class.new
    vat.save

    expect(vat.errors).to have_key(:rate)
  end

  it 'rate is greater or equal to zero' do
    vat = described_class.new(rate: -1)
    vat.save

    expect(vat.errors).to have_key(:rate)
  end

  it 'rate is a integer number' do
    vat = described_class.new(rate: 1.1)
    vat.save

    expect(vat.errors).to have_key(:rate)
  end

  it 'rate is unique' do
    vat = described_class.new(rate: 21)
    expect(vat.save).to be_truthy

    other_vat = described_class.new(rate: 21)
    expect(other_vat.save).to be_falsey

    expect(other_vat.errors).to have_key(:rate)
  end

  describe 'default' do
    let!(:vat21) { described_class.create(rate: 21, default: true) }
    let!(:vat4) { described_class.create(rate: 4, default: false) }

    it 'just one record can by the default value' do
      vat4.default = true
      expect(vat4.save).to be_truthy

      vat21.reload
      expect(vat21.default).to be_falsey
    end
  end
end
