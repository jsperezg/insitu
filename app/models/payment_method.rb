# frozen_string_literal: true

# Class that represents a paymentd method.
class PaymentMethod < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  after_save :maintain_default_flag

  has_many :invoices
  before_destroy :validate_referential_integrity

  private

  def maintain_default_flag
    return unless default

    PaymentMethod.where(default: true).where.not(id: id).each do |payment_method|
      payment_method.update(default: false)
    end
  end

  def validate_referential_integrity
    return true if invoices.count.zero?

    errors.add(:base, I18n.t('activerecord.errors.models.payment_method.used_elsewhere'))
    false
  end

  def self.default
    PaymentMethod.find_by(default: true)
  end
end
