class DashboardController < SecuredController
  def index
    unless current_user.can_invoice?
      flash[:error] = I18n.t('invoices.missing_user_data')
    end
  end
end
