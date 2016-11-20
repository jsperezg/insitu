json.vats @payment_methods.each do |payment_method|
  json.cache! payment_method do
    json.partial! 'payment_method', vat: payment_method
  end
end