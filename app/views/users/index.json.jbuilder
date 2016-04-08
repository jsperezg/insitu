json.array!(@users) do |user|
  json.extract! user, :id, :tax_id, :name, :address, :city, :country, :state, :postal_code, :phone_number, :locale, :valid_until
  json.url plan_url(plan, format: :json)
end
