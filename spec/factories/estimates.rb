# frozen_string_literal: true

FactoryBot.define do
  factory :estimate do
    customer_id { Customer.first.try(:id) || create(:customer).try(:id) }
    date { Date.today }
    valid_until { Date.today + 30.days }
    estimate_status { EstimateStatus.created }
  end
end
