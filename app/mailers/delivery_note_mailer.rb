class DeliveryNoteMailer < ApplicationMailer
  # Send the given delivery note to the customer.
  def send_to_customer(sender, delivery_note, document_path, locale)
    begin
      I18n.locale = locale.to_sym

      @delivery_note = delivery_note
      @sender = sender

      attachments["delivery_note_#{ delivery_note.number.gsub('/', '_')}.pdf"] = File.read(document_path)

      mail(to: destination_address(delivery_note.customer),
           bcc: sender.email,
           subject: default_i18n_subject(delivery_note_number: delivery_note.number, customer_name: sender.name))
    ensure
      File.delete(document_path)
    end
  end
end
