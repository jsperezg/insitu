# frozen_string_literal: true

# Controller for services related actions
class ServicesController < SecuredController
  include VatSelector

  before_action :set_service, only: %i[show edit update destroy]

  # GET /services
  # GET /services.json
  def index
    @filterrific = initialize_filterrific(
      Service,
      params[:filterrific],
      select_options: {
        with_active_criteria: Service.active_filter_options
      }

    ) || return

    @services = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show; end

  # GET /services/new
  def new
    @service = Service.new(vat_id: Vat.find_by(default: true)&.id)
  end

  # GET /services/1/edit
  def edit; end

  # POST /services
  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to user_services_path(current_user.id), notice: t(:successfully_created, item: t('services.service'))
    else
      render :new
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      redirect_to user_services_path(current_user.id), notice: t(:successfully_updated, item: t('services.service'))
    else
      render :edit
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    if @service.destroy
      redirect_to user_services_url(current_user.id), notice: t(:successfully_destroyed, item: t('services.service'))
    else
      redirect_to user_services_url(current_user.id), alert: @service.errors.full_messages.join('<br>')
    end
  end

  def csv_template
    customer_converter = CsvToServiceConverter.new
    send_data customer_converter.template, type: Mime::CSV, filename: "#{Service.model_name.human(count: 2)}.csv"
  end

  def csv_import
    csv = params[:csv_file]

    converter = CsvToServiceConverter.new
    import_service = CSVImportService.new(converter)

    result = import_service.import Rails.root.join('public', 'uploads', csv.path)
    redirect_to user_services_path(current_user), flash: { error: result.join('<br>') }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:code, :description, :vat_id, :unit_id, :price, :active)
  end
end
