# frozen_string_literal: true

# Controller that deals with the dashboard.
class DashboardController < SecuredController
  def index
    @reports = reports
  end

  private

  def reports
    Rails.cache.fetch('dashboard_content', expires_in: 24.hours) do
      TotalsCalculator.for(current_user)
    end
  end
end
