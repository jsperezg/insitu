class Task < ActiveRecord::Base
  belongs_to :project

  has_many :time_logs, dependent: :destroy

  validates :name, presence: true
  validates :project_id, presence: true
  validates :priority, numericality: { only_integer: true }, inclusion: { in: 1..5 }

  after_initialize :set_default_values
  before_validation :set_default_values
  before_save :update_finished_state

  accepts_nested_attributes_for :time_logs, reject_if: proc { |attr|
    result = true

    [:description, :start_time, :end_time, :service_id].each do |attr_id|
      result = false unless attr[attr_id].blank?
    end

    result
  }, :allow_destroy => true

  private

  def set_default_values
    self.finished ||= false
    self.priority ||= 1
  end

  def update_finished_state
    if self.finished
      self.finish_date ||= Date.today
    else
      self.finish_date = nil
    end
  end
end
