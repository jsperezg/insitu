class EstimateMailer < ApplicationMailer
  # Send the given estimate to the customer.
  def send_to_customer(sender, estimate, document_path, locale)
    begin
      I18n.locale = locale.to_sym

      @estimate = estimate
      @sender = sender

      attachments["estimate_#{ estimate.number.gsub('/', '_')}.pdf"] = File.read(document_path)

      mail(to: estimate.customer.contact_email, subject: default_i18n_subject(estimate_number: estimate.number, customer_name: invoice.customer.name))
    ensure
      File.delete(document_path)
    end
  end
end
