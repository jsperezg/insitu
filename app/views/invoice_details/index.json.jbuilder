json.array!(@invoice_details) do |invoice_detail|
  json.extract! invoice_detail, :id, :invoice_id, :service_id, :description, :vat_rate, :price
  json.url invoice_detail_url(invoice_detail, format: :json)
end
