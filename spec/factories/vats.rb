# frozen_string_literal: true

FactoryGirl.define do
  factory :vat do
    sequence :label do |n|
      "#{22 + n} %"
    end

    sequence :rate do |n|
      22 + n
    end

    trait :default do
      label '22 %'
      rate 22
      default true
    end
  end
end
