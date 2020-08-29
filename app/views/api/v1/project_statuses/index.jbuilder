# frozen_string_literal: true

json.project_statuses @project_statuses.each do |status|
  json.cache! status do
    json.partial! 'project_status', project_status: status
  end
end
