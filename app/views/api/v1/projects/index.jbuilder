# frozen_string_literal: true

json.projects @projects.each do |project|
  json.cache! project do
    json.partial! 'project', project: project
  end
end
