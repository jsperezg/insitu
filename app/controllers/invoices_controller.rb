# frozen_string_literal: true

class InvoicesController < SecuredController
  include VatSelector

  before_action :set_invoice, only: %i[show print forward_email edit update destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @filterrific = initialize_filterrific(
      Invoice,
      params[:filterrific],
      default_filter_params: {
        with_date_ge: Date.current.beginning_of_year.strftime('%Y-%m-%d'),
        sorted_by: 'date_desc'
      }
    ) || return

    @invoices = @filterrific.find.page(params[:page])
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show; end

  def print
    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        pdf = InvoicePdf.new current_user, @invoice
        send_data pdf.render, filename: "invoice_#{@invoice.number.tr('/', '_')}.pdf", type: 'application/pdf'
      end
    end
  end

  def forward_email
    unless @invoice.customer.email?
      flash[:error] = t('helpers.customer_mail_missing')
      redirect_to invoice_return_url
      return
    end

    InvoicingNotifications.call(current_user, @invoice)

    redirect_to invoice_return_url, notice: t('helpers.email_successfully_sent')
  end

  # GET /invoices/new
  def new
    payment_method = PaymentMethod.find_by(default: true)
    @invoice = Invoice.new(date: Date.current, payment_method: payment_method)
  end

  # GET /invoices/1/edit
  def edit; end

  # POST /invoices
  # POST /invoices.json
  def create
    update_user

    @invoice = Invoice.new(invoice_params)
    @invoice.apply_irpf(current_user)
    if @invoice.save
      redirect_to edit_user_invoice_url(current_user, @invoice), notice: t(:successfully_created, item: t('invoices.invoice'))
    else
      render :new
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    update_user

    if invoice_updated?
      redirect_to edit_user_invoice_path(current_user, @invoice), notice: t(:successfully_updated, item: t('invoices.invoice')) and return
    end

    @invoice.invoice_details.build
    render :edit
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    redirect_to user_invoices_url(current_user),
                notice: t(:successfully_destroyed, item: t('invoices.invoice'))
  rescue StandardError => e
    redirect_to user_invoices_url(current_user), alert: e.message
  end

  def cancel
    original_invoice = Invoice.find(params[:id])
    service = InvoiceCorrector.new(original_invoice)
    begin
      @invoice = service.cancel
      redirect_to edit_user_invoice_path(current_user, @invoice),
                  notice: t('.success')
    rescue StandardError => e
      redirect_to user_invoices_url(current_user), alert: e.record.errors.full_messages.join('<br>')
    end
  end

  def csv_export
    from_date = Date.parse(params[:from_date])
    to_date = Date.parse(params[:to_date])
    invoices = Invoice
               .includes(:customer, :invoice_details)
               .where(date: from_date..to_date)
    exporter = CsvExport.new(%i[
                               number customer date paid_on applied_irpf accumulated_tax subtotal
                             ])
    send_data exporter.run(invoices), type: Mime::CSV, filename: 'invoices.csv'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invoice_params
    params.require(:invoice).permit(
      :date,
      :number,
      :payment_method_id,
      :customer_id,
      :payment_date,
      :paid_on,
      :invoice_status_id,
      invoice_details_attributes: %i[
        id invoice_id service_id vat_rate quantity
        price discount description _destroy
      ]
    )
  end

  def invoice_return_url
    @invoice_return_url ||= request.referer || user_invoice_path(current_user.id, @invoice.id)
  end

  def invoice_updated?
    @invoice.apply_irpf(current_user)
    @invoice.update(invoice_params)
  end

  def update_user
    return unless params.key?(:user)

    current_user.update(user_params)
  end

  def user_params
    params
      .require(:user)
      .permit(:tax_id, :name, :address, :postal_code, :country)
  end
end
