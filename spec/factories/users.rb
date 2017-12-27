# frozen_string_literal: true

FactoryGirl.define do
  factory :user, class: User do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    tax_id { Faker::Company.swedish_organisation_number }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    state { Faker::Address.state }
    country { Faker::Address.country_code }

    email { Faker::Internet.email }
    password 'change_me'
    password_confirmation 'change_me'
    currency 'EUR'
    terms_of_service '1'

    trait :admin do
      role_id { Role.find_by(description: 'Administrator')&.id || create(:admin_role)&.id }
    end

    trait :expired do
      valid_until { Date.today - 7.days }
    end
  end
end
