# frozen_string_literal: true

# Controller that estimates from UI
class EstimatesController < SecuredController
  before_action :set_estimate, only: %i[show print forward_email edit update destroy invoice]

  # GET /estimates
  # GET /estimates.json
  def index
    @filterrific = initialize_filterrific(
      Estimate,
      params[:filterrific],
      default_filter_params: {
        with_date_ge: Date.today.beginning_of_year.strftime('%Y-%m-%d'),
        sorted_by: 'date_desc'
      }
    ) || return

    @estimates = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show; end

  # GET /estimates/1/print
  def print
    @estimate.sent!

    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        pdf = EstimatePdf.new current_user, @estimate
        send_data pdf.render, filename: "estimate_#{@estimate.number.tr('/', '_')}.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def forward_email
    return_url = request.referer || user_estimate_path(current_user.id, @estimate.id)

    if @estimate.customer.contact_email.blank? && @estimate.customer.send_invoices_to.blank?
      flash[:error] = t('helpers.customer_mail_missing')
      redirect_to return_url
      return
    end

    @estimate.sent!

    file_name = Rails.root.join(
      'tmp',
      "estimate_#{current_user.id}_#{@estimate.number.tr('/', '_')}_#{Time.now.to_i}.pdf"
    )

    pdf = EstimatePdf.new current_user, @estimate
    pdf.render_file(file_name)

    EstimateMailer.send_to_customer(current_user, @estimate, file_name.to_s, I18n.locale.to_s).deliver_later
    redirect_to return_url, notice: t('helpers.email_successfully_sent')
  end

  # GET /estimates/new
  def new
    @estimate = Estimate.new
  end

  # GET /estimates/1/edit
  def edit; end

  # POST /estimates
  # POST /estimates.json
  def create
    Estimate.transaction do
      @estimate = Estimate.new(estimate_params)

      if @estimate.save
        redirect_to edit_user_estimate_url(current_user, @estimate),
                    notice: t(:successfully_created, item: t('estimates.estimate'))
      else
        render :new
      end
    end
  end

  # PATCH/PUT /estimates/1
  # PATCH/PUT /estimates/1.json
  def update
    Estimate.transaction do
      if @estimate.update(estimate_params)
        redirect_to edit_user_estimate_url(current_user, @estimate),
                    notice: t(:successfully_updated, item: t('estimates.estimate'))
      else
        @estimate.estimate_details.includes(service: %i[unit vat]).build
        render :edit
      end
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate.destroy
    redirect_to user_estimates_url(current_user),
                notice: t(:successfully_destroyed, item: t('estimates.estimate'))
  end

  def invoice
    invoice = InvoiceService.call(@estimate, current_user)
    redirect_to edit_user_invoice_path(current_user, invoice)
  rescue NothingToInvoiceException
    flash[:alert] = t('estimates.nothing_to_invoice')
    redirect_to user_estimates_path(current_user)
  rescue StandardError => e
    flash[:alert] = e.message
    redirect_to user_estimates_path(current_user)
  end

  private

  def set_estimate
    @estimate = Estimate.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(
      :date,
      :number,
      :customer_id,
      :valid_until,
      :estimate_status_id,
      estimate_details_attributes: %i[
        id estimate_id service_id quantity price
        discount description _destroy
      ]
    )
  end
end
