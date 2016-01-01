class InvoiceStatus < ActiveRecord::Base
  validates :name, presence: true

  def locale_name
    I18n.t(name)
  end
end
