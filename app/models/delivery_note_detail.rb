# frozen_string_literal: true

class DeliveryNoteDetail < ActiveRecord::Base
  belongs_to :delivery_note, touch: true
  belongs_to :service
  belongs_to :invoice_detail

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def total
    price * quantity if price.present? && quantity.present?
  end
end
