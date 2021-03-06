# frozen_string_literal: true

class EstimateMailer < ApplicationMailer
  # Send the given estimate to the customer.
  def send_to_customer(sender, estimate, document_path, locale)
    I18n.locale = locale.to_sym

    @estimate = estimate
    @sender = sender

    attachments["estimate_#{estimate.number.tr('/', '_')}.pdf"] = File.read(document_path)

    mail(to: destination_address(estimate.customer),
         bcc: sender.email,
         subject: default_i18n_subject(estimate_number: estimate.number, customer_name: sender.name))
  ensure
    File.delete(document_path)
  end
end
