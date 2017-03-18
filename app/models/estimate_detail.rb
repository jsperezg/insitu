class EstimateDetail < ActiveRecord::Base
  belongs_to :estimate, touch: true
  belongs_to :service
  belongs_to :invoice_detail

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def total
    if price.present? && quantity.present? && discount.present?
      ( 1 - (discount / 100.0)) * price * quantity
    end
  end
end
