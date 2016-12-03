json.tasks @tasks.each do |task|
  json.cache! task do
    json.partial! 'task', unit: task
  end
end