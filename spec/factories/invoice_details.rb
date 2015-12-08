FactoryGirl.define do
  factory :invoice_detail do    
    service_id { Service.first.try(:id) || create(:service).id }
	  description "Test invoice detail"
	  vat_rate 21
    price 9.99
    discount 0
    quantity 1
  end
end
