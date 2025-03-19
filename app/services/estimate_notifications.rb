# frozen_string_literal: true

class EstimateNotifications < ApplicationService
  def initialize(from, estimate)
    super

    @from = from
    @estimate = estimate
  end

  def call
    estimate.sent!
    EstimateMailer.send_to_customer(current_user, @estimate, estimate_file, I18n.locale.to_s).deliver_later
  end

  private

  attr_reader :from, :estimate

  def estimate_file
    @estimate_file ||= begin
      file_name = Rails.root.join(
        'tmp',
        "estimate_#{from.id}_#{estimate.number.tr('/', '_')}_#{Time.now.to_i}.pdf"
      )

      pdf = EstimatePdf.new from, estimate
      pdf.render_file(file_name)

      file_name
    end
  end
end
