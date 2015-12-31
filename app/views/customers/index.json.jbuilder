json.array!(@customers) do |customer|
  json.extract! customer, :id, :name
end
