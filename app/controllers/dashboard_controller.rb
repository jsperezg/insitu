class DashboardController < SecuredController
  def index
    unless current_user.can_invoice?
      flash[:error] = I18n.t('invoices.missing_user_data')
    end

    @reports = {}

    # @reports[:past_year] = calculate_totals (DateTime.now - 1.year).beginning_of_year, (DateTime.now - 1.year).end_of_year
    @reports[:current_year] = calculate_totals DateTime.now.beginning_of_year, DateTime.now.end_of_year
    # @reports[:current_month] = calculate_totals DateTime.now.beginning_of_month, DateTime.now.end_of_month
    # @reports[:last_year] = calculate_totals DateTime.now - 12.months, DateTime.now
  end

  def calculate_totals(from_date, to_date)
    result = {}

    result[:net] = InvoiceDetail
                         .includes(:invoice)
                         .where('invoices.date': from_date..to_date)
                         .sum('(1 - discount / 100) * price * quantity')

    result[:discounts] = InvoiceDetail
                         .includes(:invoice)
                         .where('invoices.date': from_date..to_date)
                         .sum('(discount / 100) * price * quantity')

    result[:tax] = InvoiceDetail
                         .includes(invoice: [ :customer ])
                         .where('invoices.date': from_date..to_date)
                         .where.not('customers.irpf': nil)
                         .sum('(1 - discount / 100) * price * quantity * (customers.irpf / 100)') if current_user.country == 'ES'



    result[:vat] = InvoiceDetail
                       .includes(:invoice)
                       .where('invoices.date': from_date..to_date)
                       .group(:vat_rate)
                       .sum('(1 - discount / 100) * price * quantity * (vat_rate / 100)')

    customers = InvoiceDetail
                          .includes(invoice: [ :customer ])
                          .where('invoices.date': from_date..to_date)
                          .group('customers.name')
                          .sum('(1 - discount / 100) * price * quantity')
    result[:customers] = customers.select { |t| customers[t] >= 3000 }

    result
  end

  private :calculate_totals
end
