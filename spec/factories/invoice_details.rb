FactoryGirl.define do
  factory :invoice_detail do
    invoice_id { Invoice.first&.id || create(:invoice).id }
    service_id { Service.first&.id || create(:service).id }
	  description 'Test invoice detail'
	  vat_rate 21
    price 9.99
    discount 0
    quantity 1
  end
end
