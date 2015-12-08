class InvoiceDetail < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :service

  validates :service_id, presence: true
  validates :vat_rate, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    
  def total
    if price.present? && quantity.present? && discount.present? && vat_rate.present?
	    v = ( 1 - (discount / 100.0)) * price * quantity

      v + v * (vat_rate / 100.0)
    end
	end
end
