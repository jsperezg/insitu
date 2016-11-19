json.array!(@customers) do |customer|
  json.cache! customer do
    json.extract! customer, :id, :name
  end
end
