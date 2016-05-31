FactoryGirl.define do
  factory :user, class: User do
    after(:create) { |user| user.confirm }

    name { "#{Faker::Name.first_name} #{ Faker::Name.last_name }" }
    tax_id { Faker::Company.swedish_organisation_number }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    state { Faker::Address.state }
    country { Faker::Address.country_code }

    email { Faker::Internet.email }
    password 'change_me'
    password_confirmation 'change_me'
  end

  factory :expired_user, class: User do
    after(:create) { |user| user.confirm }

    email { Faker::Internet.email }

    valid_until { Date.today - 7.days }

    name { "#{Faker::Name.first_name} #{ Faker::Name.last_name }" }
    tax_id { Faker::Company.swedish_organisation_number }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    state { Faker::Address.state }
    country { Faker::Address.country_code }

    password 'change_me'
    password_confirmation 'change_me'
  end

  factory :admin_user, class: User do
    after(:create) { |user| user.confirm }

    email { Faker::Internet.email }

    role_id { Role.find_by(description: 'Administrator').try(:id) || create(:admin_role).try(:id) }

    password 'change_me'
    password_confirmation 'change_me'
  end
end
