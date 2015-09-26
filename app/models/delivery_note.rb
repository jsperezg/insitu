class DeliveryNote < ActiveRecord::Base
  belongs_to :customer

  validates :customer_id, presence: true
  validates :date, presence: true
end
