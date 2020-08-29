# frozen_string_literal: true

class TimeLog < ActiveRecord::Base
  belongs_to :task, touch: true
  belongs_to :service
  belongs_to :invoice_detail

  validates :description, presence: true
  validates :time_spent, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :service_id, presence: true
  validates :date, presence: true
end
