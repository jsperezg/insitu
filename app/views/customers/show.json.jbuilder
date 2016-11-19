cache @customer do
  json.extract! @customer, :id, :created_at, :updated_at
end
