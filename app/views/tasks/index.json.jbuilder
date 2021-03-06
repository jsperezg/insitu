# frozen_string_literal: true

json.array!(@tasks) do |task|
  json.cache! task do
    json.extract! task, :id, :name, :description, :project_id, :finish_date, :dead_line, :priority
    json.time_logs task.time_logs do |time_log|
      json.cache! time_log do
        json.extract! time_log, :id, :description, :date, :time_spent, :service_id, :invoice_detail_id
      end
    end
  end
end
