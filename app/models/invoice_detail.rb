class InvoiceDetail < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :service
  has_one :time_log, dependent: :nullify
  has_one :estimate_detail, dependent: :nullify
  has_one :delivery_note_detail, dependent: :nullify

  validates :service_id, presence: true
  validates :vat_rate, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  after_initialize :set_default_values, if: :new_record?

  def subtotal
    if price.present? && quantity.present?
      price * quantity
    end
  end

  def applied_discount
    if price.present? && quantity.present? && discount.present?
      discount / 100.0 * subtotal
    end
  end

  def tax
    if price.present? && quantity.present? && discount.present? && vat_rate.present?
      ( 1 - (discount / 100.0)) * price * quantity * ( vat_rate / 100.0)
    end
  end

  def total
    if price.present? && quantity.present? && discount.present? && vat_rate.present?
	    ( 1 - (discount / 100.0)) * price * quantity * ( 1 + (vat_rate / 100.0))
    end
  end

  private

  def set_default_values
    self.vat_rate = Vat.find_by(default: true).try(:rate) if self.vat_rate.nil?
  end
end
