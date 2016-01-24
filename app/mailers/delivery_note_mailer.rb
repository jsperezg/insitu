class DeliveryNoteMailer < ApplicationMailer
  # Send the given delivery note to the customer.
  def send_to_customer(sender, delivery_note, document_path, locale)
    begin
      I18n.locale = locale.to_sym

      @delivery_note = delivery_note
      @sender = sender

      attachments["delivery_note_#{ delivery_note.number.gsub('/', '_')}.pdf"] = File.read(document_path)

      mail(to: delivery_note.customer.contact_email, subject: default_i18n_subject(delivery_note_number: delivery_note.number, customer_name: invoice.customer.name))
    ensure
      File.delete(document_path)
    end
  end
end
