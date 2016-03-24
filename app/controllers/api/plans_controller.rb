class Api::PlansController < ApiController
  def index
    render json: Plan.where(is_active: true).order(months: :asc), except: [:is_active, :created_at, :updated_at]
  end
end
