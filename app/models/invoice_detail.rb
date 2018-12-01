# frozen_string_literal: true

# Class encapsulates CRUD operations for invoice details.
class InvoiceDetail < ActiveRecord::Base
  belongs_to :invoice, touch: true
  belongs_to :service
  has_one :time_log, dependent: :nullify
  has_one :estimate_detail, dependent: :nullify
  has_one :delivery_note_detail, dependent: :nullify

  validates :vat_rate,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }

  validates :price, presence: true, numericality: { greater_than: 0 }

  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }, unless: :amending_invoice?

  validates :discount,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }

  before_validation :set_default_values

  def subtotal
    return unless price.present? && quantity.present?

    price * quantity
  end

  def applied_discount
    return unless price.present? && quantity.present? && discount.present?

    discount / 100.0 * subtotal
  end

  def tax
    return unless price.present? && quantity.present? && discount.present? && vat_rate.present?

    (1 - (discount / 100.0)) * price * quantity * (vat_rate / 100.0)
  end

  def total
    return unless price.present? && quantity.present? && discount.present? && vat_rate.present?

    (1 - (discount / 100.0)) * price * quantity * (1 + (vat_rate / 100.0))
  end

  def amending_invoice?
    invoice&.amending_invoice?
  end

  private

  def set_default_values
    self.discount ||= 0
    self.vat_rate ||= Vat.default&.rate
  end
end
