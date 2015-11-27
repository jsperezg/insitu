FactoryGirl.define do
  factory :invoice do
	date { Date.today }
	payment_method { PaymentMethod.first || create(:payment_method).try(:id) }
	customer { Customer.first || create(:customer).try(:first) }
  end
end
