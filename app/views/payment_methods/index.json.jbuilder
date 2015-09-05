json.array!(@payment_methods) do |payment_method|
  json.extract! payment_method, :id, :name, :note_for_invoice
  json.url payment_method_url(payment_method, format: :json)
end
