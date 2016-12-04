json.payment_methods @payment_methods.each do |payment_method|
  json.cache! payment_method do
    json.partial! 'payment_method', payment_method: payment_method
  end
end