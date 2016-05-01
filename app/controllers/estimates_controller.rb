class EstimatesController < SecuredController
  before_action :set_estimate, only: [:show, :print, :forward_email, :edit, :update, :destroy, :invoice]

  # GET /estimates
  # GET /estimates.json
  def index
    @filterrific = initialize_filterrific(
        Estimate,
        params[:filterrific],
        select_options: {
            sorted_by: Estimate.options_for_sorted_by
        },
        default_filter_params: {
            with_date_ge: I18n.l(Date.today.beginning_of_year),
            sorted_by: 'date_desc'
        }
    ) or return

    @estimates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
  end

  # GET /estimates/1/print
  def print
    unless @estimate.sent?
      @estimate.estimate_status = EstimateStatus.find_by(name: 'estimate_status.sent')
      @estimate.save
    end

    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        pdf = EstimatePdf.new current_user, @estimate
        send_data pdf.render, filename: "estimate_#{ @estimate.number.gsub('/', '_') }.pdf", type: 'application/pdf'
      end
    end
  end

  def forward_email
    if @estimate.customer.contact_email.blank? and @estimate.customer.send_invoices_to.blank?
      flash[:error] = t('helpers.customer_mail_missing')
      redirect_to user_estimate_path(current_user.id, @estimate.id)
      return
    end

    unless @estimate.sent?
      @estimate.estimate_status = EstimateStatus.find_by(name: 'estimate_status.sent')
      @estimate.save
    end

    file_name = Rails.root.join('tmp', "estimate_#{ current_user.id }_#{ @estimate.number.gsub('/', '_') }_#{ Time.now.to_i }.pdf")

    pdf = EstimatePdf.new current_user, @estimate
    pdf.render_file(file_name)

    EstimateMailer.send_to_customer(current_user, @estimate, file_name, I18n.locale.to_s).deliver_later
    redirect_to user_estimate_path(current_user.id, @estimate.id), notice: t('helpers.email_successfully_sent')
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new
    @estimate.estimate_details.build
  end

  # GET /estimates/1/edit
  def edit
    @estimate.estimate_details.includes(service: [ :unit, :vat ]).build
  end

  # POST /estimates
  # POST /estimates.json
  def create
    Estimate.transaction do
      @estimate = Estimate.new(estimate_params)

      respond_to do |format|
        if @estimate.save
          format.html {
            redirect_to edit_user_estimate_url(current_user, @estimate),
            notice: t(:successfully_created, item: t('estimates.estimate'))
          }
          format.json { render :show, status: :created, location: @estimate }
        else
          format.html { render :new }
          format.json { render json: @estimate.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /estimates/1
  # PATCH/PUT /estimates/1.json
  def update
    Estimate.transaction do
      respond_to do |format|
        if @estimate.update(estimate_params)
          format.html {
            redirect_to edit_user_estimate_url(current_user, @estimate),
                        notice: t(:successfully_updated, item: t('estimates.estimate'))
          }
          format.json { render :show, status: :ok, location: @estimate }
        else
          format.html {
            @estimate.estimate_details.includes(service: [ :unit, :vat ]).build
            render :edit
          }
          format.json { render json: @estimate.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate.destroy
    respond_to do |format|
      format.html {
        redirect_to user_estimates_url(current_user),
        notice: t(:successfully_destroyed, item: t('estimates.estimate'))
      }
      format.json { head :no_content }
    end
  end

  def invoice
    payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
    unless payment_method
      flash[:alert] = t('payment_methods.not_found')
      redirect_to edit_user_estimate_path(current_user, @estimate)
      return
    end

    Invoice.transaction do
      unless @estimate.accepted?
        @estimate.estimate_status = EstimateStatus.find_by(name: 'estimate_status.accepted')
        @estimate.save
      end

      invoice = Invoice.create(
          date: Date.today,
          payment_date: Date.today + 15.days,
          customer_id: @estimate.customer_id,
          payment_method_id: payment_method.id
      )

      invoice.apply_irpf(current_user)

      # Iterate over estimate details.
      details = EstimateDetail.where(estimate_id: @estimate.id, invoice_detail_id: nil)
      details.each do |detail|
        invoice_detail = InvoiceDetail.create(
          invoice_id: invoice.id,
          service_id: detail.service_id,
          vat_rate: detail.service.vat.rate,
          price: detail.price,
          discount: detail.discount,
          description: detail.description,
          quantity: detail.quantity
        )

        detail.invoice_detail_id = invoice_detail.id
        detail.save
      end

      if invoice.invoice_details.empty?
        flash[:alert] = t('estimates.nothing_to_invoice')
        redirect_to edit_user_estimate_path(current_user, @estimate)
        raise ActiveRecord::Rollback
      else
        redirect_to edit_user_invoice_path(current_user, invoice)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estimate_params
      params.require(:estimate).permit(
        :date,
        :number,
        :customer_id,
        :valid_until,
        :estimate_status_id,
        estimate_details_attributes: [
          :id, :estimate_id, :service_id, :quantity, :price,
          :discount, :description, :_destroy
        ]
      )
    end
end
