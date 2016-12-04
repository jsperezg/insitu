json.array!(@invoices) do |invoice|
  json.cache! invoice do
    json.extract! invoice, :id, :number, :date, :payment_method_id, :customer_id, :issue_date, :payment_date, :paid_on
  end
end
