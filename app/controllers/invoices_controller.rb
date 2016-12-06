class InvoicesController < SecuredController
  include InvoicingNotifications

  before_action :set_invoice, only: [:show, :print, :forward_email, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @filterrific = initialize_filterrific(
      Invoice,
      params[:filterrific],
      default_filter_params: {
          with_date_ge: I18n.l(Date.today.beginning_of_year),
          sorted_by: 'date_desc'
      }
    ) or return

    @invoices = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  def print
    if @invoice.created?
      @invoice.invoice_status = InvoiceStatus.find_by(name: 'invoice_status.sent')
      @invoice.save
    end

    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        pdf = InvoicePdf.new current_user, @invoice
        send_data pdf.render, filename: "invoice_#{ @invoice.number.gsub('/', '_') }.pdf", type: 'application/pdf'
      end
    end
  end

  def forward_email
    if @invoice.created?
      @invoice.invoice_status = InvoiceStatus.find_by(name: 'invoice_status.sent')
      @invoice.save
    end

    if @invoice.customer.contact_email.blank? and @invoice.customer.send_invoices_to.blank?
      flash[:error] = t('helpers.customer_mail_missing')
      redirect_to user_invoice_path(current_user.id, @invoice.id)
      return
    end

    send_invoice_by_email(current_user, @invoice)

    redirect_to user_invoice_path(current_user.id, @invoice.id), notice: t('helpers.email_successfully_sent')
  end

  # GET /invoices/new
  def new
    payment_method = PaymentMethod.find_by(default: true)
    @invoice = Invoice.new(date: Date.today, payment_method: payment_method)
    @invoice.invoice_details.build
  end

  # GET /invoices/1/edit
  def edit
    @invoice.invoice_details.build
  end

  # POST /invoices
  # POST /invoices.json
  def create
    Invoice.transaction do
      @invoice = Invoice.new(invoice_params)

      @invoice.apply_irpf(current_user)

      respond_to do |format|
        if @invoice.save
          format.html {
            redirect_to edit_user_invoice_url(current_user, @invoice),
            notice: t(:successfully_created, item: t('invoices.invoice'))
          }

          format.json { render :show, status: :created, location: @invoice }
        else
          format.html { render :new }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    Invoice.transaction do
      @invoice.apply_irpf(current_user)

      respond_to do |format|
        if @invoice.update(invoice_params)
          format.html {
            redirect_to edit_user_invoice_path(current_user, @invoice),
            notice: t(:successfully_updated, item: t('invoices.invoice'))
          }
          format.json { render :show, status: :ok, location: @invoice }
        else
          format.html {
            @invoice.invoice_details.build
            render :edit
          }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html {
        redirect_to user_invoices_url(current_user),
        notice: t(:successfully_destroyed, item: t('invoices.invoice'))
      }
      format.json { head :no_content }
    end
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
      invoice_details_attributes: [
        :id, :invoice_id, :service_id, :vat_rate, :quantity, :price,
        :discount, :description, :_destroy
      ]
    )
  end
end
