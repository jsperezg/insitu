# frozen_string_literal: true

json.cache! invoice do
  json.extract! invoice, :id, :number, :date, :payment_method_id, :customer_id, :invoice_status_id, :payment_date, :paid_on, :irpf
  json.invoice_details invoice.invoice_details do |detail|
    json.cache! detail do
      json.extract! detail, :id, :service_id, :description, :vat_rate, :quantity, :price, :discount
    end
  end
end
