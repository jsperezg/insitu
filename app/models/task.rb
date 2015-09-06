class Task < ActiveRecord::Base
  belongs_to :project

  validates :description, presence: true
  validates :project_id, presence: true
end
