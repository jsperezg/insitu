FactoryGirl.define do
  factory :invoice do
  	date { Date.today }
  	payment_method_id { PaymentMethod.first.try(:id) || create(:payment_method).try(:id) }
  	customer_id { Customer.first.try(:id) || create(:customer).try(:id) }
  	payment_date { Date.today + 15.days }
  end
end
