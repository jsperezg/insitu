json.cache! @payment_method do
  json.extract! @payment_method, :id, :name, :note_for_invoice, :default
end
