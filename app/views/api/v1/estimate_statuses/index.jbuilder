# frozen_string_literal: true

json.estimate_statuses @estimate_statuses.each do |status|
  json.cache! status do
    json.partial! 'estimate_status', estimate_status: status
  end
end
