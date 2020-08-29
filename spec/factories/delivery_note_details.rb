# frozen_string_literal: true

FactoryBot.define do
  factory :delivery_note_detail do
    delivery_note_id { DeliveryNote.first.try(:id) || create(:delivery_note).id }
    service_id { Service.first.try(:id) || create(:service).id }

    sequence :description do |n|
      "delivery note #{n}"
    end

    quantity { 1 }
    price { 1 }
  end
end
