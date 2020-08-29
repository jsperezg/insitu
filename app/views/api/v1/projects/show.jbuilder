# frozen_string_literal: true

json.cache! @project do
  json.partial! 'project', project: @project
end
