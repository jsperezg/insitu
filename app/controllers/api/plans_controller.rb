class Api::PlansController < ApiController
  def index
    render json: Plan.where(is_active: true).order(months: :asc)
  end
end
