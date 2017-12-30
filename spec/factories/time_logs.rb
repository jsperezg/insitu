FactoryBot.define do
  factory :time_log do
    sequence :description do |n|
      "Time log #{ n }"
    end

    time_spent 120
    date { Date.today }
    task_id { Task.first.try(:id) || create(:task).id }
    service_id { Service.first.try(:id) || create(:service).id }
  end

end
