FactoryGirl.define do
  factory :task do
    sequence :description do |n|
      "Task #{ n }"
    end

    project_id { Project.first.try(:id) || create(:project).id }
    finished false
  end

end
