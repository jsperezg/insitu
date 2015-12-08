class EstimateDetail < ActiveRecord::Base
  belongs_to :estimate
  belongs_to :service
end
