class DashboardController < SecuredController
  def index
    @reports = InvoiceDetail.calculate_totals_for(current_user)
  end

end
