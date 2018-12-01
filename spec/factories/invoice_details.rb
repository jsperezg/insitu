# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_detail do
    invoice
    service
    description { 'Test invoice detail' }
    vat_rate { 21 }
    price { 9.99 }
    discount { 0 }
    quantity { 1 }
  end
end
