json.cache! @task do
  json.extract! @task, :id, :name, :description, :project_id, :finish_date, :dead_line, :priority
end
