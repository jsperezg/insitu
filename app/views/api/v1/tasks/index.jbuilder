# frozen_string_literal: true

json.tasks @tasks.each do |task|
  json.partial! 'task', task: task
end
