class InvoiceStatus < ApplicationRecord
  validates :name, presence: true
  has_many :invoices

  def locale_name
    I18n.t(name)
  end
end
