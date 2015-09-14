class Invoice < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :customer

  validates :number, presence: true
  validates :date, presence: true
  validates :payment_method_id, presence: true
  validates :customer_id, presence: true
  validates :issue_date, presence: true
  validates :payment_date, presence: true
end
