# frozen_string_literal: true

class EstimateDetail < ApplicationRecord
  belongs_to :estimate, touch: true
  belongs_to :service, optional: true
  belongs_to :invoice_detail, optional: true

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def total
    (1 - (discount / 100.0)) * price * quantity if price.present? && quantity.present? && discount.present?
  end
end
