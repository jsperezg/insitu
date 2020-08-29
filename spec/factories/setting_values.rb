# frozen_string_literal: true

FactoryBot.define do
  factory :setting_value do
    value_i { 1 }
    value_s { 'MyString' }
    value_b { false }
    value_d { '2015-11-14' }
    setting_key { nil }
  end
end
