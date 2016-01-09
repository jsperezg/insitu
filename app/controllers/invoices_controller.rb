class InvoicesController < SecuredController
  before_action :set_invoice, only: [:show, :print, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.order(date: :desc)
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  def print
    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        render pdf: "invoice_#{ @invoice.number.gsub('/', '_') }", viewport_size: '1920x1080'
      end
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new(date: Date.today)
    @invoice.invoice_details.build
  end

  # GET /invoices/1/edit
  def edit
    @invoice_detail = InvoiceDetail.new
    @invoice.invoice_details.build
  end

  # POST /invoices
  # POST /invoices.json
  def create
    Invoice.transaction do
      @invoice = Invoice.new(invoice_params)

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
      respond_to do |format|
        if @invoice.update(invoice_params)
          format.html {
            redirect_to edit_user_invoice_path(current_user, @invoice),
            notice: t(:successfully_updated, item: t('invoices.invoice'))
          }
          format.json { render :show, status: :ok, location: @invoice }
        else
          format.html { render :edit }
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
