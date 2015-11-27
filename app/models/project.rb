class Project < ActiveRecord::Base
  belongs_to :project_status
  belongs_to :customer

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :project_status_id, presence: true
  validates :customer_id, presence: true
end
