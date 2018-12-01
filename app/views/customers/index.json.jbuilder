# frozen_string_literal: true

json.array!(@customers) do |customer|
  json.cache! customer do
    json.extract! customer, :id, :name, :tax_id, :billing_serie, :irpf, :contact_name, :contact_phone,
                  :contact_email, :address, :city, :postal_code, :state, :country, :send_invoices_to
  end
end
