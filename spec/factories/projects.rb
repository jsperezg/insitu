# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence :name do |n|
      "Project #{n}"
    end

    project_status_id { ProjectStatus.first.try(:id) || create(:project_status).id }
    customer_id { Customer.first.try(:id) || create(:customer).id }
  end
end
