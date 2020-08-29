# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliveryNote, type: :model do
  before do
    Thread.current[:user] = User.first || create(:user)
  end

  it 'customer is mandatory' do
    deliver_note = DeliveryNote.new
    deliver_note.save

    expect(deliver_note.errors).to have_key(:customer_id)
  end

  it 'date is mandatory' do
    deliver_note = DeliveryNote.new
    deliver_note.save

    expect(deliver_note.errors).to have_key(:date)
  end

  describe 'Delivery note series' do
    it 'generic series' do
      delivery_note = create(:delivery_note)

      delivery_note.reload

      expect(delivery_note.errors).to be_empty
      expect(delivery_note.number).to start_with(DeliveryNote.model_name.human[0].capitalize)
    end

    it 'do not allow duplicates' do
      delivery_note = build(:delivery_note, number: "I/#{Date.today.year}/000001")
      delivery_note.save

      expect(delivery_note.errors).to be_empty

      another_delivery_note = build(:delivery_note, number: "I/#{Date.today.year}/000001")
      another_delivery_note.save

      expect(another_delivery_note.errors).to have_key(:number)
    end

    it 'update default series for estimates' do
      delivery_note = build(:delivery_note, number: "X/#{Date.today.year}/000001")
      delivery_note.save

      expect(delivery_note.errors).to be_empty

      another_delivery_note = create(:delivery_note)
      another_delivery_note.reload

      expect(another_delivery_note.number).to eq("X/#{Date.today.year}/000002")
    end

    it 'Sequence is updated after updating the document' do
      document1 = create(:delivery_note, number: "I/#{Date.today.year}/000001")
      expect(document1.number).to end_with('000001')

      document2 = create(:delivery_note)
      expect(document2.number).to end_with('000002')

      document1.destroy

      document2.number = document1.number
      expect(document2.save).to be_truthy

      document2 = create(:delivery_note)
      expect(document2.number).to end_with('000002')
    end

    it 'Sequence is updated after removing last document' do
      document1 = create(:delivery_note, number: "I/#{Date.today.year}/000001")
      expect(document1.number).to end_with('000001')

      document2 = create(:delivery_note)
      expect(document2.number).to end_with('000002')

      document2.destroy

      document2 = create(:delivery_note)
      expect(document2.number).to end_with('000002')
    end
  end

  describe 'Number format validation' do
    it 'First capital letter' do
      delivery_note = build(:delivery_note, number: "i/#{Date.today.year}/000001")
      delivery_note.save

      expect(delivery_note.errors).to have_key(:number)
    end

    it 'Same year as bill' do
      delivery_note = build(:delivery_note, number: "i/#{Date.today.year + 1}/000001")
      delivery_note.save

      expect(delivery_note.errors).to have_key(:number)
    end

    it '6 digits' do
      delivery_note = build(:delivery_note, number: "i/#{Date.today.year}/xxxxxx")
      delivery_note.save

      expect(delivery_note.errors).to have_key(:number)
    end
  end

  it 'valid delivery  notes' do
    10.times do
      delivery_note = build(:delivery_note)
      delivery_note.save

      expect(delivery_note.errors).to be_empty
    end
  end
end
