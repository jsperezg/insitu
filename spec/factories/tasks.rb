# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence :name do |n|
      "Task #{n}"
    end

    sequence :description do |n|
      "This is along description for task #{n}"
    end

    priority { 1 }

    project_id { Project.first.try(:id) || create(:project).id }
    dead_line { Date.current + 7.days }
  end
end
