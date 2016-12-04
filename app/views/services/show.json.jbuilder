json.cache! @service do
  json.extract! @service, :id, :code, :description, :vat_id, :unit_id, :price, :active
end
