# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    sequence :description do |n|
      "#{n} month"
    end

    sequence :price do |n|
      n
    end

    sequence :months do |n|
      n
    end

    vat_rate { 21 }
    is_active { true }
  end
end
