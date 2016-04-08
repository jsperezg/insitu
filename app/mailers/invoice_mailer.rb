class InvoiceMailer < ApplicationMailer
  # Send the given invoice to the customer.
  def send_to_customer(sender, invoice, document_path, locale)
    begin
      I18n.locale = locale.to_sym

      @invoice = invoice
      @sender = sender

      attachments["invoice_#{ invoice.number.gsub('/', '_')}.pdf"] = File.read(document_path)

      mail(to: destination_address(invoice.customer), subject: default_i18n_subject(invoice_number: invoice.number, customer_name: invoice.customer.name))
    ensure
      File.delete(document_path)
    end
  end
end
