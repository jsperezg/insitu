# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    sequence :name do |n|
      "Customer #{n}"
    end

    sequence :tax_id do |n|
      "tax_id_#{n}"
    end

    billing_serie { 'A' }
    irpf { 15 }

    contact_name { "Contact: #{name}" }

    sequence :contact_phone do |n|
      "6870#{n}"
    end

    sequence :contact_email do |n|
      "address_#{n}@domain.com"
    end

    postal_code { '00000' }
    country { 'ES' }
    address { 'test street, 1' }
  end
end
