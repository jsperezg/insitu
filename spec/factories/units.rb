# frozen_string_literal: true

FactoryBot.define do
  factory :unit do
    sequence :label_short do |n|
      "U#{n}"
    end

    sequence :label_long do |n|
      "Unit #{n}"
    end
  end
end
