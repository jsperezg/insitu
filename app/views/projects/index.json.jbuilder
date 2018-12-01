# frozen_string_literal: true

json.array!(@projects) do |project|
  json.cache! project do
    json.extract! project, :id, :name, :project_status_id, :customer_id
  end
end
