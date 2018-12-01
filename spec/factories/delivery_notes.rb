# frozen_string_literal: true

FactoryBot.define do
  factory :delivery_note do
    customer_id { Customer.first.try(:id) || create(:customer).id }
    date { Time.now }
  end
end
