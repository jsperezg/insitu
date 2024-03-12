# frozen_string_literal: true

require 'rails_helper'

describe DeliveryNoteDetail, type: :model do
  describe 'quantity' do
    it 'is mandatory' do
      deliver_note_detail = described_class.new
      deliver_note_detail.save

      expect(deliver_note_detail.errors).to be_key :quantity
    end

    it 'must be a number' do
      deliver_note_detail = described_class.new(quantity: 'asdf')
      deliver_note_detail.save

      expect(deliver_note_detail.errors).to be_key :quantity
    end

    it 'is greater than zero' do
      deliver_note_detail = described_class.new(quantity: 0)
      deliver_note_detail.save

      expect(deliver_note_detail.errors).to be_key :quantity
    end
  end

  describe 'price' do
    it 'is mandatory' do
      deliver_note_detail = described_class.new
      deliver_note_detail.save

      expect(deliver_note_detail.errors).to be_key :price
    end

    it 'must be a number' do
      deliver_note_detail = described_class.new(price: 'asdf')
      deliver_note_detail.save

      expect(deliver_note_detail.errors).to be_key :price
    end

    it 'is greater than zero' do
      deliver_note_detail = described_class.new(price: 0)
      deliver_note_detail.save

      expect(deliver_note_detail.errors).to be_key :price
    end
  end

  it 'total is quantity x price' do
    delivery_note_detail = described_class.new(quantity: 10.0, price: 18.0)
    expect(delivery_note_detail.total).to eq(180.0)
  end
end
