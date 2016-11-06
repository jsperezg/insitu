json.net period_data.net
json.discounts period_data.discounts
json.tax period_data.tax

json.vat do
  period_data.vat.each do |rate, total|
    json.set! rate, total
  end
end

json.customers do
  period_data.customers.each do |name, total|
    json.set! name, total
  end
end