# frozen_string_literal: true

class Role < ApplicationRecord
  scope :admin, -> { find_by(description: 'Administrator') }
  scope :user, -> { find_by(description: 'User') }
end
