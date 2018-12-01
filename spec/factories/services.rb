# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence :code do |n|
      "BS/#{n.to_s.rjust(4)}"
    end

    description { 'Body shopping' }
    vat_id { Vat.find_by(default: true)&.id || Vat.create(rate: 21, default: true).id }
    unit_id { Unit.first.try(:id) || create(:unit).id }
    price { 25 }
    active { true }
  end
end
