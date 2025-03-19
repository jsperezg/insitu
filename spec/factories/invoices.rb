# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    date { Date.current }
    payment_method_id { PaymentMethod.first.try(:id) || create(:payment_method).try(:id) }
    customer_id { Customer.first.try(:id) || create(:customer).try(:id) }
    payment_date { Date.current + 15.days }
    invoice_status_id { InvoiceStatus.first.try(:id) || create(:invoice_status).try(:id) }
    irpf { 0 }
  end
end
