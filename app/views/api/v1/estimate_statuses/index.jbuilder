json.projects @estimate_statuses.each do |status|
  json.cache! status do
    json.partial! 'estimate_statuses', estimate_statuses: status
  end
end