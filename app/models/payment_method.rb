class PaymentMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  after_save :maintain_default_flag

  has_many :invoices
  before_destroy :validate_referential_integrity

  private

  def maintain_default_flag
    if self.default
      PaymentMethod.where(default: true).where.not(id: self.id).each do |payment_method|
        payment_method.update(default: false)
      end
    end
  end

  def validate_referential_integrity
    return true if invoices.count.zero?

    errors.add(:base, I18n.t('activerecord.errors.models.payment_method.used_elsewhere'))
    throw(:abort)
  end
end
