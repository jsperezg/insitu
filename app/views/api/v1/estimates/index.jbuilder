# frozen_string_literal: true

json.estimates @estimates.each do |estimate|
  json.partial! 'estimate', estimate: estimate
end
