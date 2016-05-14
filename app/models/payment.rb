class Payment < ActiveRecord::Base
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
  validates :mc_gross, presence: true
  validates :tax, presence: true
  validates :mc_fee, presence: true
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
    errors[:receiver_email] = "Receiver email #{ receiver_email } is not allowed" if receiver_email != Rails.configuration.x.paypal_receiver_email
  end

  def payment_currency_is_valid
    errors[:mc_currency] = "Invalid currencty. Only EUR is accepted." if mc_currency != 'EUR'
  end

  def payment_amount_is_valid
    unless plan.nil?
      expected_amount = plan.price * (1 + plan.vat_rate / 100.0)
      errors[:mc_gross] = "Invalid amount. #{ expected_amount} € was expected." if mc_gross != expected_amount
    end
  end

  private :receiver_email_is_valid, :payment_currency_is_valid
end
