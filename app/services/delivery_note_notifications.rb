# frozen_string_literal: true

class DeliveryNoteNotifications < ApplicationService
  def initialize(user, delivery_note)
    super

    @user = user
    @delivery_note = delivery_note
  end

  def call
    DeliveryNoteMailer.send_to_customer(current_user, @delivery_note, delivery_note_file, I18n.locale.to_s).deliver_later
  end

  private

  attr_reader :user, :delivery_note

  def delivery_note_file
    @delivery_note_file ||= begin
      file_name = Rails.root.join(
        'tmp',
        "delivery_note_#{current_user.id}_#{delivery_note.number.tr('/', '_')}_#{Time.now.to_i}.pdf"
      )

      pdf = DeliveryNotePdf.new user, delivery_note
      pdf.render_file(file_name)

      file_name
    end
  end
end
