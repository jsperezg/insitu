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
end
