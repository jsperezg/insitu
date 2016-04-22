require 'rails_helper'

RSpec.describe Estimate, type: :model do
  before(:each) do
    Thread.current[:user] = User.first || create(:user)
  end

  it "customer is mandatory" do
    estimate = Estimate.new
    estimate.save

    expect(estimate.errors).to satisfy { |errors| errors.key? :customer_id }
  end

  it "date is today by default" do
    estimate = Estimate.new
    estimate.save

    expect(estimate.date).to eq(Date.today)
  end

  it 'valid_until must be after date' do
    estimate = Estimate.new(valid_until: Date.today, date: Date.today + 3.days)
    estimate.save

    expect(estimate.errors).to satisfy { |errors| errors.key? :valid_until }
  end

  it "status is mandatory" do
    estimate = Estimate.new
    estimate.save

    expect(estimate.errors).to satisfy { |errors| errors.key? :estimate_status_id }
  end

  describe 'Estimate serie' do
    it 'generic serie' do
      estimate = create(:estimate)

      estimate.reload

      expect(estimate.errors.empty?).to be(true)
      expect(estimate.number).to start_with(Estimate.model_name.human[0].capitalize)
    end

    it 'do not allow duplicates' do
      estimate = build(:estimate, number: "I/#{ Date.today.year }/000001")
      estimate.save

      expect(estimate.errors.empty?).to be(true)

      another_estimate = build(:estimate, number: "I/#{ Date.today.year }/000001")
      another_estimate.save

      expect(another_estimate.errors).to satisfy { |errors| errors.key? :number }
    end

    it 'update default serie for estimates' do
      estimate = build(:estimate, number: "X/#{ Date.today.year }/000001")
      estimate.save

      expect(estimate.errors.empty?).to be(true)

      another_estimate = create(:estimate)
      another_estimate.reload

      expect(another_estimate.number).to eq("X/#{ Date.today.year }/000002")
    end
  end

  describe 'Number format validation' do
    it 'First capital letter' do
      estimate = build(:estimate, number: "i/#{ Date.today.year }/000001")
      estimate.save

      expect(estimate.errors).to satisfy { |errors| errors.key? :number }
    end

    it 'Same year as bill' do
      estiamte = build(:estimate, number: "i/#{ Date.today.year + 1 }/000001")
      estiamte.save

      expect(estiamte.errors).to satisfy { |errors| errors.key? :number }
    end

    it '6 digits' do
      estimate = build(:estimate, number: "i/#{ Date.today.year}/xxxxxx")
      estimate.save

      expect(estimate.errors).to satisfy { |errors| errors.key? :number }
    end
  end

  it 'valid estimates' do
    10.times do
      estimate = build(:estimate)
      estimate.save

      expect(estimate.errors.empty?).to be(true)
    end
  end

  it 'expired user cant save delivery notes' do
    Thread.current[:user] = create(:expired_user)
    object = Estimate.new
    object.save

    expect(object.errors).to satisfy { |errors| !errors.empty? && errors.key?( :base )}
    expect(object.errors[:base]).to include(I18n.t('activerecord.errors.messages.subscription_expired'))
  end
end
