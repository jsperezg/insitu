FactoryGirl.define do
  factory :time_log do
    sequence :description do |n|
      "Time log #{ n }"
    end

    start_time { DateTime.now - 2.hours }
    end_time  { DateTime.now }
    task_id { Task.first.try(:id) || create(:task).id }
    service_id { Service.first.try(:id) || create(:service).id }
  end

end
