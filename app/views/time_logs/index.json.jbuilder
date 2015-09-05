json.array!(@time_logs) do |time_log|
  json.extract! time_log, :id, :description, :start_time, :end_time, :project_id
  json.url time_log_url(time_log, format: :json)
end
