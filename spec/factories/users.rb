FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@fges_tests.com"
    end

    password 'change_me'
    password_confirmation 'change_me'
  end

  factory :admin_user, class: User do
    sequence :email do |n|
      "admin_#{n}@fges_tests.com"
    end

    role_id { Role.find_by(description: 'Administrator').try(:id) || create(:admin_role).try(:id) }

    password 'change_me'
    password_confirmation 'change_me'
  end
end
