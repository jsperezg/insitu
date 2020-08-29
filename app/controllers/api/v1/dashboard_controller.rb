# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApiController
      def index
        @reports = TotalsCalculator.for(current_user)
      end
    end
  end
end
