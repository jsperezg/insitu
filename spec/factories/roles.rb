# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    description { 'User' }
  end

  factory :admin_role, class: 'Role' do
    description { 'Administrator' }
  end
end
