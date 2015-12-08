FactoryGirl.define do
  factory :estimate do
    customer { Customer.first.try(:id) || create(:customer).try(:id) }
    date { Date.today }
    valid_until { Date.today + 30.days }
  end
end
