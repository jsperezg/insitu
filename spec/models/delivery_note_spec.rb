# frozen_string_literal: true

require 'rails_helper'

describe DeliveryNote, type: :model do
  subject { build :delivery_note, customer: customer, date: date }

  let(:customer) { create :customer }
  let(:date) { Time.now }

  before do
    Thread.current[:user] = User.first || create(:user)
  end

  it { is_expected.to be_valid }

  describe 'when customer is nil' do
    let(:customer) { nil }

    it { is_expected.not_to be_valid }
  end

  describe 'when date is nil' do
    let(:date) { nil }

    it { is_expected.not_to be_valid }
  end

  describe 'Delivery note series' do
    it 'generic series' do
      delivery_note = create(:delivery_note)

      delivery_note.reload

      expect(delivery_note.errors).to be_empty
      expect(delivery_note.number).to start_with(described_class.model_name.human[0].capitalize)
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

  it 'valid delivery notes' do
    10.times do
      delivery_note = build(:delivery_note)
      delivery_note.save

      expect(delivery_note).to be_valid
    end
  end
end
