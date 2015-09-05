json.array!(@tasks) do |task|
  json.extract! task, :id, :description, :project_id, :finished
  json.url task_url(task, format: :json)
end
