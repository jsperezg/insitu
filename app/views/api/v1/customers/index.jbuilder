json.customers @customers.each do |customer|
  json.cache! customer do
    json.partial! 'customer', customer: customer
  end
end