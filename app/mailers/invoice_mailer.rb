class InvoiceMailer < ApplicationMailer
  # Send the given invoice to the customer.
  def send_to_customer(sender, invoice, document_path, locale)
    begin
      I18n.locale = locale.to_sym

      @invoice = invoice
      @sender = sender

      attachments["invoice_#{ invoice.number.gsub('/', '_')}.pdf"] = File.read(document_path)

      mail(to: invoice.customer.contact_email, subject: default_i18n_subject(invoice_number: invoice.number))
    ensure
      File.delete(document_path)
    end
  end
end
