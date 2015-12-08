FactoryGirl.define do
  factory :delivery_note_detail do
  	service { Service.first.try(:id) || create(:service).id }
  	quantity 1
  	price 1
  end
end
