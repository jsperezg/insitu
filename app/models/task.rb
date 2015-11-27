class Task < ActiveRecord::Base
  belongs_to :project

  has_many :time_logs, dependent: :destroy

  validates :description, presence: true
  validates :project_id, presence: true
end
