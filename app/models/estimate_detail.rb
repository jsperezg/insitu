class EstimateDetail < AbstractSubscriptionValidator
  belongs_to :estimate
  belongs_to :service
  belongs_to :invoice_detail

  validates :service_id, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def total
    if price.present? && quantity.present? && discount.present?
      ( 1 - (discount / 100.0)) * price * quantity
    end
  end
end
