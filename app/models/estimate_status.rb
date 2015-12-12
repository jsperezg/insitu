class EstimateStatus < ActiveRecord::Base
  def locale_name
    I18n.t(name)
  end
end
