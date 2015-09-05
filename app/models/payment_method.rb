class PaymentMethod < ActiveRecord::Base
  validates :name, presence: true
end
