class Api::V1::PlansController < ActionController::Base
  def index
    @plans = Plan.where(is_active: true).order(months: :asc)
  end
end
