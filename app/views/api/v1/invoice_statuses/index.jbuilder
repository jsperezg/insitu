json.invoice_statuses @invoice_statuses.each do |status|
  json.cache! status do
    json.partial! 'invoice_status', invoice_status: status
  end
end