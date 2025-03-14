# frozen_string_literal: true

class InvoiceService < ApplicationService
  def initialize(document, user)
    super()
    @document = document
    @user = user
  end

  def call
    raise I18n.t('payment_methods.not_found') unless payment_method

    Invoice.transaction do
      update_document_status

      invoice.apply_irpf(@user)
      invoice.save!

      create_invoice_details

      raise NothingToInvoiceException if invoice.invoice_details.empty?
    end

    invoice
  end

  private

  def create_invoice_details
    details.each do |detail|
      invoice_detail = invoice_detail_for(detail)
      detail.invoice_detail_id = invoice_detail.id
      detail.save!
    end
  end

  def invoice_detail_for(detail)
    InvoiceDetail.create(
      invoice_id: invoice.id,
      service_id: detail.service_id,
      vat_rate: detail.service.vat.rate,
      price: detail.price,
      discount: detail.respond_to?(:discount) ? detail.discount : 0,
      description: detail.description,
      quantity: quantity_for(detail)
    )
  end

  def quantity_for(detail)
    return detail.time_spent / 60.0 if detail.is_a? TimeLog

    detail.quantity
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
      DeliveryNoteDetail.where(delivery_note_id: @document.id, invoice_detail_id: nil)
    when Estimate
      EstimateDetail.where(estimate_id: @document.id, invoice_detail_id: nil)
    when Project
      task_ids = Task.joins(:project).where(project_id: @document.id).where.not(finish_date: nil).pluck(:id)
      TimeLog.includes(:service).where(task_id: task_ids, invoice_detail_id: nil)
    else
      []
    end
  end

  def update_document_status
    return unless @document.is_a?(Estimate)
    return if @document.accepted?

    @document.estimate_status = EstimateStatus.accepted
    @document.save!
  end
end
