json.response do
  json.array! @plans do |plan|
    json.cache! plan do
      json.id plan.id
      json.description plan.description
      json.months plan.months
      json.vat_rate  plan.vat_rate
      json.price  plan.price
    end
  end
end