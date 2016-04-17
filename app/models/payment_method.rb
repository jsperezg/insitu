class PaymentMethod < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  after_save :maintain_default_flag, on: [ :create, :update ]

  has_many :invoices
  before_destroy :validate_referential_integrity

  private

  def maintain_default_flag
    if self.default
      PaymentMethod.where(default: true).where.not(id: self.id).update_all(default: false)
    end
  end

  def validate_referential_integrity
    return true if invoices.count == 0

    errors.add(:base, I18n.t('activerecord.errors.models.payment_method.used_elsewhere'))
    false
  end
end
