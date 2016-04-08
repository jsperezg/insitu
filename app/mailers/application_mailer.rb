class ApplicationMailer < ActionMailer::Base
  require 'open-uri'

  default from: ENV['default_from']
  layout 'mailer'

  def destination_address(customer)
    destination_address = customer.send_invoices_to
    destination_address = customer.contact_email if destination_address.blank?

    destination_address
  end
end
