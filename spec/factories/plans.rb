FactoryGirl.define do
  factory :plan do
    description '1 month'
    price 5.00
    months 1
    vat_rate 21
  end
end
