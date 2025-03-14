# frozen_string_literal: true

class InvoiceService < ApplicationService
  def initialize(document, user, discount = 0)
    super()
    @document = document
    @user = user
    @discount = discount
  end

  def call
    raise I18n.t('payment_methods.not_found') unless payment_method

    Invoice.transaction do
      invoice.apply_irpf(@user)
      create_invoice_details

      raise I18n.t('delivery_notes.nothing_to_invoice') if invoice.invoice_details.empty?
    end

    invoice
  end

  private

  def create_invoice_details
    details.each do |detail|
      invoice_detail = InvoiceDetail.create(
        invoice_id: invoice.id,
        service_id: detail.service_id,
        vat_rate: detail.service.vat.rate,
        price: detail.price,
        discount: @discount,
        description: detail.description,
        quantity: detail.quantity
      )

      detail.invoice_detail_id = invoice_detail.id
      detail.save!
    end
  end

  def payment_method
    @payment_method ||= PaymentMethod.default
  end

  def invoice
    @invoice ||= Invoice.create(
      date: Date.today,
      payment_date: Date.today + 15.days,
      customer_id: @document.customer_id,
      payment_method_id: payment_method.id
    )
  end

  def details
    case @document
    when DeliveryNote
      DeliveryNoteDetail.where(delivery_note_id: @delivery_note.id, invoice_detail_id: nil)
    when Estimate
      EstimateDetail.where(estimate_id: @document.id, invoice_detail_id: nil)
    else
      []
    end
  end
end
