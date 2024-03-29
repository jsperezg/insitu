# frozen_string_literal: true

require 'rails_helper'

describe EstimateDetail, type: :model do
  describe 'quantity' do
    it 'is mandatory' do
      estimate_detail = described_class.new
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :quantity
    end

    it 'must be a number' do
      estimate_detail = described_class.new(quantity: 'asdf')
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :quantity
    end

    it 'is greater than zero' do
      estimate_detail = described_class.new(quantity: 0)
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :quantity
    end
  end

  describe 'price' do
    it 'is mandatory' do
      estimate_detail = described_class.new
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :price
    end

    it 'must be a number' do
      estimate_detail = described_class.new(price: 'asdf')
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :price
    end

    it 'is greater than zero' do
      estimate_detail = described_class.new(price: 0)
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :price
    end
  end

  describe 'discount' do
    it 'is zero by default' do
      estimate_detail = described_class.new
      estimate_detail.save

      expect(estimate_detail.discount).to equal 0
    end

    it 'must be a number' do
      estimate_detail = described_class.new(discount: 'asdf')
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :discount
    end

    it 'is greater or equal to zero' do
      estimate_detail = described_class.new(discount: -1)
      estimate_detail.save

      expect(estimate_detail.errors).to be_key :discount
    end
  end

  it 'total is quantity x price' do
    delivery_note_detail = described_class.new(quantity: 10.0, price: 18.0, discount: 0)
    expect(delivery_note_detail.total).to eq(180.0)
  end
end
