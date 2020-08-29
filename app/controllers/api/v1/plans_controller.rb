# frozen_string_literal: true

module Api
  module V1
    class PlansController < ActionController::Base
      def index
        @plans = Plan.where(is_active: true).order(months: :asc)
      end
    end
  end
end
