FactoryGirl.define do
  factory :estimate_detail do
    service { Service.first.try(:id) || create(:service).try(:id) }
    quantity 1.0
    description "custom estimate detail"
    price 1.0
    discount 1.0
  end
end
