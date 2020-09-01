# frozen_string_literal: true

FactoryBot.define do
  factory :delivery_note do
    association :customer
    date { Time.now }
  end
end
