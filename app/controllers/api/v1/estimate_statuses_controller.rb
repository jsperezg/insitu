class Api::V1::EstimateStatusesController < ApiController
  include Api

  before_action :set_estimate_status, only: [:show]

  def index
    @estimate_statuses = EstimateStatus.all
  end

  def show
  end

  private

  def set_estimate_status
    @estimate_status = EstimateStatus.find(params[:id])
  end
end