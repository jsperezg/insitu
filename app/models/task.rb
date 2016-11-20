class Task < ActiveRecord::Base
  include ApartmentCacheKeyGenerator

  belongs_to :project

  has_many :time_logs, dependent: :destroy

  validates :name, presence: true
  validates :project_id, presence: true
  validates :priority, numericality: { only_integer: true }, inclusion: { in: 1..5 }

  after_initialize :set_default_values
  before_validation :set_default_values

  accepts_nested_attributes_for :time_logs, reject_if: proc { |attr|
    result = true

    [:description, :time_spent, :date, :service_id].each do |attr_id|
      result = false unless attr[attr_id].blank?
    end

    result
  }, :allow_destroy => true

  private

  def set_default_values
    self.priority ||= 1
  end
end
