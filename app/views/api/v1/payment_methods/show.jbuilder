json.cache! @payment_method do
  json.partial! 'payment_method', vat: @payment_method
end