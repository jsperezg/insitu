class Payment < ApplicationRecord
  enum payment_status: {
      canceled_reversal: 'Canceled_Reversal',
      completed: 'Completed',
      created: 'Created',
      denied: 'Denied',
      expired: 'Expired',
      failed: 'Failed',
      pending: 'Pending',
      refunded: 'Refunded',
      reversed: 'Reversed',
      processed: 'Processed',
      voided: 'Voided'
  }

  validates :txn_id, presence: true, uniqueness: true, length: { maximum: 19 }
  validates :business, presence: true, length: { maximum: 127 }
  validates :receiver_email, presence: true, length: { maximum:  127 }
  validates :receiver_id, presence: true, length: { maximum: 13 }
  validates :residence_country, length: { maximum: 2 }
  validates :user_id, presence: true
  validates :payer_id, presence: true, length: { maximum: 13 }
  validates :payer_email, presence: true, length: { maximum: 127 }
  validates :payer_status, presence: true, length: { maximum: 10 }
  validates :last_name, length: { maximum: 64 }
  validates :first_name, length: { maximum: 64 }
  validates :payment_date, presence: true
  validates :payment_status, presence: true, length: { maximum: 25 }
  validates :payment_type, presence: true, length: { maximum: 7 }
  validates :txn_type, presence: true, length: { maximum: 50 }
  validates :mc_gross, presence: true, numericality: true
  validates :tax, presence: true, numericality: true
  validates :mc_fee, presence: true, numericality: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :plan_id, presence: true
  validates :mc_currency, presence: true, length: { maximum: 5 }
  validates :notify_version, length: { maximum: 25 }

  # Request validation
  validate :receiver_email_is_valid
  validate :payment_currency_is_valid
  validate :payment_amount_is_valid

  belongs_to :plan
  belongs_to :user

  def receiver_email_is_valid
    errors[:receiver_email] = I18n.t('activerecord.errors.models.payment.attributes.receiver_email.invalid_value', email: receiver_email ) if receiver_email != Rails.configuration.x.paypal_receiver_email
  end

  def payment_currency_is_valid
    errors[:mc_currency] = I18n.t('activerecord.errors.models.payment.attributes.mc_currency.invalid_value') if mc_currency != 'EUR'
  end

  def payment_amount_is_valid
    unless plan.nil?
      expected_amount = plan.price * (1 + plan.vat_rate / 100.0)
      errors[:mc_gross] = I18n.t('activerecord.errors.models.payment.attributes.mc_gross.invalid_value') if mc_gross != expected_amount
    end
  end

  def renew_user
    user = self.user
    user.valid_until = self.payment_date + self.plan.months.months
    user.save!

    self.processed_at = DateTime.now
    self.save!
  end

  private :receiver_email_is_valid, :payment_currency_is_valid
end
