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
        send_data pdf.render, filename: "estimate_#{ @estimate.number.gsub('/', '_') }.pdf", type: 'application/pdf', disposition: 'inline'
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

    unless @estimate.sent?
      @estimate.estimate_status = EstimateStatus.find_by(name: 'estimate_status.sent')
      @estimate.save
    end

    file_name = Rails.root.join(
      'tmp',
      "estimate_#{current_user.id}_#{@estimate.number.gsub('/', '_')}_#{Time.now.to_i}.pdf"
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

      respond_to do |format|
        if @estimate.save
          format.html do
            redirect_to edit_user_estimate_url(current_user, @estimate),
                        notice: t(:successfully_created, item: t('estimates.estimate'))
          end
          format.json { render :show, status: :created, location: @estimate }
        else
          format.html { render :new }
          format.json do
            render json: @estimate.errors, status: :unprocessable_entity
          end
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
          format.html do
            redirect_to edit_user_estimate_url(current_user, @estimate),
                        notice: t(:successfully_updated, item: t('estimates.estimate'))
          end
          format.json {render :show, status: :ok, location: @estimate}
        else
          format.html do
            @estimate.estimate_details.includes(service: %i[unit vat]).build
            render :edit
          end
          format.json do
            render json: @estimate.errors, status: :unprocessable_entity
          end
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
      format.json {head :no_content}
    end
  end

  def invoice
    begin
      invoice_generator = InvoiceGenerator.new
      invoice = invoice_generator.from_estimate(@estimate)

      invoice.apply_irpf(current_user)
      invoice.save!

      redirect_to edit_user_invoice_path(current_user, invoice)
    rescue => error
      flash[:alert] = t(error.message)
      redirect_to user_estimates_path(current_user)
    end
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
