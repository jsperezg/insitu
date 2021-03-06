# frozen_string_literal: true

module InvoicingNotifications
  def send_invoice_by_email(from, invoice)
    file_name = Rails.root.join('tmp', "invoice_#{from.id}_#{invoice.number.tr('/', '_')}_#{Time.now.to_i}.pdf")

    pdf = InvoicePdf.new from, invoice
    pdf.render_file file_name

    InvoiceMailer.send_to_customer(from, invoice, file_name.to_s, I18n.locale.to_s).deliver_later
  end
end
