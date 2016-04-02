FactoryGirl.define do
  factory :service do
    sequence :code do |n|
      "BS/#{ n.to_s.rjust(4) }"
    end

    description "Body shoping"
    vat_id { Vat.first.try(:id) || create(:vat).id }
    unit_id { Unit.first.try(:id) || create(:unit).id }
    price 25
    active true
  end

end
