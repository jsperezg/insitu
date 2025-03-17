# frozen_string_literal: true

FactoryBot.define do
  factory :payment_method do
    sequence :name do |n|
      "Payment method #{n}"
    end

    note_for_invoice { 'Note  for invoice' }

    trait :default do
      name { 'invoice_status.default' }
    end
  end
end
