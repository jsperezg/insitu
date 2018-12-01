# frozen_string_literal: true

json.cache! @project_status do
  json.partial! 'project_status', project_status: @project_status
end
