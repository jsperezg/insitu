class Invoice < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :customer
end
