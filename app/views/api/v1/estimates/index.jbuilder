json.tasks @estimates.each do |estimate|
  json.partial! 'estimate', estimate: estimate
end