class Api::V1::DashboardController < ApiController
  def index
    @reports = InvoiceDetail.calculate_totals_for(current_user)
  end
end