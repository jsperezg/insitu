FactoryGirl.define do
  factory :delivery_note do    
	customer_id { Customer.first.try(:id) || create(:customer).id }
	date { DateTime.now }
  end
end
