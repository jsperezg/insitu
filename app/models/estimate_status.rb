# frozen_string_literal: true

class EstimateStatus < ApplicationRecord
  has_many :estimates, dependent: :restrict_with_error

  scope :created, -> { find_by(name: 'estimate_status.created') }
  scope :sent, -> { find_by(name: 'estimate_status.sent') }
  scope :accepted, -> { find_by(name: 'estimate_status.accepted') }

  def locale_name
    I18n.t(name)
  end
end
