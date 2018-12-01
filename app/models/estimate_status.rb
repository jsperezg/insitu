# frozen_string_literal: true

class EstimateStatus < ActiveRecord::Base
  has_many :estimates

  def locale_name
    I18n.t(name)
  end
end
