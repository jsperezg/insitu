FactoryGirl.define do
  factory :service do
    code "BS/0001"
    description "Body shoping"
    vat_id { Vat.first.try(:id) || create(:vat).id }
    unit_id { Unit.first.try(:id) || create(:unit).id }
    price 25
  end

end
