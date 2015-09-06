FactoryGirl.define do
  factory :customer do
    sequence :name do |n|
      "Customer #{n}"
    end

    sequence :tax_id do |n|
      "tax_id_#{n}"
    end

    billing_serie "A"
    billing_tax 21

    contact_name { name }

    contact_phone "0034600000000"
    sequence :contact_email do |n|
      "address_#{n}@domain.com"
    end
  end

end
