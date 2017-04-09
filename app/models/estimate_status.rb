# Estimate status
class EstimateStatus < ApplicationRecord
  has_many :estimates

  def locale_name
    I18n.t(name)
  end
end
