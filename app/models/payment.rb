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
  #
  # enum pending_reason: {
  #     address: 'address',
  #     authorization: 'authorization',
  #     echeck: 'echeck',
  #     intl: 'intl',
  #     multi_currency: 'multi_currency',
  #     order: 'order',
  #     paymentreview: 'paymentreview',
  #     regulatory_review: 'regulatory_review',
  #     unilateral: 'unilateral',
  #     upgrade: 'upgrade',
  #     verify: 'verify',
  #     other: 'other'
  # }
  #
  # enum reason_code: {
  #     adjustment_reversal: 'adjustment_reversal',
  #     admin_fraud_reversal: 'admin_fraud_reversal',
  #     admin_reversal: 'admin_reversal',
  #     buyer_complaint: 'buyer-complaint',
  #     chargeback: 'chargeback',
  #     chargeback_reimbursement: 'chargeback_reimbursement',
  #     chargeback_settlement: 'chargeback_settlement',
  #     guarantee: 'guarantee',
  #     other: 'other',
  #     refund: 'refund',
  #     regulatory_block: 'regulatory_block',
  #     regulatory_reject: 'regulatory_reject',
  #     regulatory_review_exceeding_sla: 'regulatory_review_exceeding_sla',
  #     unauthorized_claim: 'unauthorized_claim',
  #     unauthorized_spoof: 'unauthorized_spoof'
  # }

  validates :txn_id, presence: true, uniqueness: true
end
