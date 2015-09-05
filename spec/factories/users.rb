FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@fges_tests.com"
    end

    password 'change_me'
    password_confirmation 'change_me'
  end
end
