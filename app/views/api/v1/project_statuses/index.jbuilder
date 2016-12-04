json.projects @project_statuses.each do |status|
  json.cache! status do
    json.partial! 'project_status', project_status: status
  end
end