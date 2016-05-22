module InvoicingNotifications
  def send_invoice_by_email(from, invoice)
    file_name =  Rails.root.join('tmp', "invoice_#{ from.id }_#{ invoice.number.gsub('/', '_') }_#{ Time.now.to_i }.pdf")

    pdf = InvoicePdf.new from, invoice
    pdf.render_file file_name

    InvoiceMailer.send_to_customer(from, invoice, file_name, I18n.locale.to_s).deliver_later
  end
end