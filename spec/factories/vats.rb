# frozen_string_literal: true

FactoryGirl.define do
  factory :vat do
    sequence(:rate, 23) { |n| n }
    label { "#{rate} %" }

    trait :default do
      default true
    end

    trait :default do
      label '22 %'
      rate 22
      default true
    end
  end
end
