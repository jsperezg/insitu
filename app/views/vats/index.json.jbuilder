json.array!(@vats) do |vat|
  json.extract! vat, :id
  json.url vat_url(vat, format: :json)
end
