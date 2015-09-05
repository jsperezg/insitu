class Project < ActiveRecord::Base
  belongs_to :project_status
  belongs_to :customer
end
