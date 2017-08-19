# frozen_string_literal: true

# Service that amend invoices
class InvoiceCorrector
  include SequenceGenerator

  def initialize(invoice)
    @invoice = invoice
  end

  def cancel
    Invoice.transaction do
      amended_invoice = create_cancellation_header
      create_cancellation_details(amended_invoice)
      amended_invoice
    end
  end

  private

  def create_cancellation_header
    date = DateTime.now

    Invoice.create!(
      number: generate_id(AMENDING_INVOICE_SERIES, date.year, 2),
      date: date,
      customer_id: @invoice.customer_id,
      invoice_status_id: InvoiceStatus.default&.id,
      irpf: @invoice.irpf,
      amended_invoice_id: @invoice.id,
      payment_method_id: @invoice.payment_method_id
    )
  end

  def create_cancellation_details(amended_invoice)
    @invoice.invoice_details.each do |detail|
      InvoiceDetail.create!(
        invoice_id: amended_invoice.id,
        service_id: detail.service_id,
        description: detail.description,
        vat_rate: detail.vat_rate,
        price: detail.price,
        quantity: -detail.quantity,
        discount: detail.discount
      )
    end
  end
end