json.array!(@services) do |service|
  json.extract! service, :id, :code, :description, :vat_id, :unit_id, :price
  json.url service_url(service, format: :json)
end
