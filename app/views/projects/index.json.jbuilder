json.array!(@projects) do |project|
  json.extract! project, :id, :name, :project_status_id, :customer_id
  json.url project_url(project, format: :json)
end
