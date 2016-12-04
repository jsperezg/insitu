json.services @services.each do |service|
  json.cache! service do
    json.partial! 'service', service: service
  end
end