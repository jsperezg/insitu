FactoryGirl.define do
  factory :user, class: User do
    after(:create) { |user| user.confirm }

    email { Faker::Internet.email }
    password 'change_me'
    password_confirmation 'change_me'
  end

  factory :expired_user, class: User do
    after(:create) { |user| user.confirm }

    email { Faker::Internet.email }

    valid_until { Date.today - 7.days }

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
