# frozen_string_literal: true

json.services @services.each do |service|
  json.partial! 'service', service: service
end
