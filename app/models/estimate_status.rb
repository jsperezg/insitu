# frozen_string_literal: true

class EstimateStatus < ApplicationRecord
  has_many :estimates

  scope :created, -> { find_by(name: 'estimate_status.created') }
  scope :sent, -> { find_by(name: 'estimate_status.sent') }

  def locale_name
    I18n.t(name)
  end
end
