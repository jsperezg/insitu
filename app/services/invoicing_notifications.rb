# frozen_string_literal: true

class InvoicingNotifications < ApplicationService
  def initialize(from, invoice)
    super

    @from = from
    @invoice = invoice
  end

  def call
    update_invoice_status
    InvoiceMailer.send_to_customer(from, invoice, pdf_file, I18n.locale.to_s).deliver_later
  end

  private

  attr_reader :from, :invoice

  def update_invoice_status
    return unless invoice.created?

    invoice.update(invoice_status: InvoiceStatus.sent)
  end

  def pdf_file
    @pdf_file ||= begin
      file_name = Rails.root.join('tmp', "invoice_#{from.id}_#{invoice.number.tr('/', '_')}_#{Time.now.to_i}.pdf")

      pdf = InvoicePdf.new from, invoice
      pdf.render_file file_name

      file_name
    end
  end
end
