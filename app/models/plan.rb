class Plan < ActiveRecord::Base
  validates :description, presence: true
  validates :price, presence: true, :numericality => { greater_than: 0 }
  validates :months, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :vat_rate, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :is_active, presence: true
end
