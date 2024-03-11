# frozen_string_literal: true

require 'rails_helper'

describe Estimate, type: :model do
  before do
    Thread.current[:user] = User.first || create(:user)
  end

  it 'customer is mandatory' do
    estimate = described_class.new
    estimate.save

    expect(estimate.errors).to have_key(:customer_id)
  end

  it 'date is today by default' do
    estimate = described_class.new
    estimate.save

    expect(estimate.date).to eq(Date.today)
  end

  it 'valid_until must be after date' do
    estimate = described_class.new(valid_until: Date.today, date: Date.today + 3.days)
    estimate.save

    expect(estimate.errors).to have_key(:valid_until)
  end

  it 'status fallbacks to the default value' do
    estimate = create(:estimate, estimate_status: nil)
    expect(estimate.estimate_status).to eq(EstimateStatus.created)
  end

  describe 'Estimate series' do
    it 'generic series' do
      estimate = create(:estimate)

      estimate.reload

      expect(estimate.errors).to be_empty
      expect(estimate.number).to start_with(described_class.model_name.human[0].capitalize)
    end

    it 'do not allow duplicates' do
      estimate = build(:estimate, number: "I/#{Date.today.year}/000001")
      estimate.save

      expect(estimate.errors).to be_empty

      another_estimate = build(:estimate, number: "I/#{Date.today.year}/000001")
      another_estimate.save

      expect(another_estimate.errors).to have_key(:number)
    end

    it 'update default series for estimates' do
      estimate = build(:estimate, number: "X/#{Date.today.year}/000001")
      estimate.save

      expect(estimate.errors).to be_empty

      another_estimate = create(:estimate)
      another_estimate.reload

      expect(another_estimate.number).to eq("X/#{Date.today.year}/000002")
    end

    it 'Sequence is updated after updating the document' do
      document1 = create(:estimate)
      expect(document1.number).to end_with('000001')

      document2 = create(:estimate)
      expect(document2.number).to end_with('000002')

      document1.destroy

      document2.number = document1.number
      expect(document2.save).to be_truthy

      document2 = create(:estimate)
      expect(document2.number).to end_with('000002')
    end

    it 'Sequence is updated after removing last document' do
      document1 = create(:estimate)
      expect(document1.number).to end_with('000001')

      document2 = create(:estimate)
      expect(document2.number).to end_with('000002')

      document2.destroy

      document2 = create(:estimate)
      expect(document2.number).to end_with('000002')
    end
  end

  describe 'Number format validation' do
    it 'First capital letter' do
      estimate = build(:estimate, number: "i/#{Date.today.year}/000001")
      estimate.save

      expect(estimate.errors).to have_key(:number)
    end

    it 'Same year as bill' do
      estimate = build(:estimate, number: "i/#{Date.today.year + 1}/000001")
      estimate.save

      expect(estimate.errors).to have_key(:number)
    end

    it '6 digits' do
      estimate = build(:estimate, number: "i/#{Date.today.year}/xxxxxx")
      estimate.save

      expect(estimate.errors).to have_key(:number)
    end
  end

  it 'valid estimates' do
    10.times do
      estimate = build(:estimate)
      expect(estimate.save).to be_truthy
    end
  end
end
