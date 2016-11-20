json.cache! @payment_method do
  json.partial! 'payment_method', payment_method: @payment_method
end