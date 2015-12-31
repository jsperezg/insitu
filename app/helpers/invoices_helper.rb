module InvoicesHelper
  def payment_status invoice
    now = Date.today

    if invoice[:paid_on].present?
      return 'success'
    end

    if invoice[:payment_date] < now
      return 'danger'
    end    

    'info'
  end
end
