# frozen_string_literal: true

class InvoiceGenerator
  attr_accessor :payment_method

  def initialize
    @payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
    raise 'payment_methods.not_found' unless @payment_method
  end

  def from_estimate(estimate)
    invoice = nil

    Invoice.transaction do
      estimate.update!(estimate_status: EstimateStatus.accepted) unless estimate.accepted?
      invoice = create_invoice_header(estimate.customer_id)

      # Iterate over estimate details.
      details = EstimateDetail
                .includes(service: [:vat])
                .where(estimate_id: estimate.id, invoice_detail_id: nil)
      details.each do |detail|
        generate_invoice_detail(invoice, detail, detail.discount || 0)
      end

      raise 'estimates.nothing_to_invoice' if invoice.invoice_details.empty?
    end

    invoice
  end

  def from_delivery_note(delivery_note)
    invoice = nil

    Invoice.transaction do
      invoice = create_invoice_header(delivery_note.customer_id)

      # Iterate over estimate details.
      details = DeliveryNoteDetail
                .includes(service: [:vat])
                .where(delivery_note_id: delivery_note.id, invoice_detail_id: nil)
      details.each do |detail|
        generate_invoice_detail(invoice, detail)
      end

      raise 'delivery_notes.nothing_to_invoice' if invoice.invoice_details.empty?
    end

    invoice
  end

  private

  def generate_invoice_detail(invoice, detail, discount = 0)
    invoice_detail = InvoiceDetail.create!(
      invoice_id: invoice.id,
      service_id: detail.service.id,
      vat_rate: detail.service.vat.rate,
      price: detail.price,
      discount: discount,
      description: detail.description,
      quantity: detail.quantity
    )

    detail.update!(invoice_detail_id: invoice_detail.id)
  end

  def create_invoice_header(customer_id)
    invoice = Invoice.create(
      date: Date.today,
      payment_date: Date.today + 15.days,
      customer_id: customer_id,
      payment_method_id: @payment_method.id
    )

    raise invoice.errors.full_messages.join(', ') if invoice.invalid?

    invoice
  end
end
