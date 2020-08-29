# frozen_string_literal: true

FactoryBot.define do
  factory :estimate_detail do
    estimate_id { Estimate.first.try(:id) || create(:estimate).id }
    service_id { Service.first.try(:id) || create(:service).try(:id) }
    quantity { 1.0 }
    description { 'custom estimate detail' }
    price { 1.0 }
    discount { 1 }
  end
end
