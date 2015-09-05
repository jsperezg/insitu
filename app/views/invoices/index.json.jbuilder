json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :number, :date, :payment_method_id, :customer_id, :issue_date, :payment_date, :paid_on
  json.url invoice_url(invoice, format: :json)
end
