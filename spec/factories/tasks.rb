FactoryGirl.define do
  factory :task do
    sequence :name do |n|
      "Task #{ n }"
    end

    sequence :description do |n|
      "This is along description for task #{n}"
    end

    priority 1

    project_id { Project.first.try(:id) || create(:project).id }
    finished false
    dead_line { Date.today + 7.days }
  end

end
