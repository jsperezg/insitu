class DashboardController < SecuredController
  def index
    @reports = reports
  end

  private

  def reports
    Rails.cache.fetch('dashboard_content', expires_in: 24.hours) do
      InvoiceDetail.calculate_totals_for(current_user)
    end
  end

end
