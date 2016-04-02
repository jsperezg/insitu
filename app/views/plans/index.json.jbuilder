json.array!(@plans) do |plan|
  json.extract! plan, :id, :description, :price, :months, :is_active, :vat_rate
  json.url plan_url(plan, format: :json)
end
