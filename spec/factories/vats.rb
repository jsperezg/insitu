# frozen_string_literal: true

FactoryBot.define do
  factory :vat do
    sequence(:rate, 23) { |n| n }
    default { false }

    trait :default do
      default { true }
    end
  end
end
