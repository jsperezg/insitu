class TimeLog < ActiveRecord::Base
  belongs_to :task
  belongs_to :service

  validates :description, presence: true
  validates :start_time, presence: true
  validates :task_id, presence: true
  validates :service_id, presence: true

  validate :start_time_is_before_end_time

  def start_time_is_before_end_time
    if start_time.present? and end_time.present? and start_time >= end_time
      errors.add(:start_time, I18n.t('activerecord.errors.models.time_log.start_time.invalid_value'))
    end
  end
end
