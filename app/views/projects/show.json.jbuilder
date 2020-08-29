# frozen_string_literal: true

json.cache! @project do
  json.extract! @project, :id, :name, :project_status_id, :customer_id
end
