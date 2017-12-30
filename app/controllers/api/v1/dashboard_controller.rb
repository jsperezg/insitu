# frozen_string_literal: true

class Api::V1::DashboardController < ApiController
  def index
    @reports = TotalsCalculator.for(current_user)
  end
end