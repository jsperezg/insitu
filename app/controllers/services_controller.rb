class ServicesController < SecuredController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.includes(:vat, :unit).paginate(page: params[:page], per_page: DEFAULT_ITEMS_PER_PAGE).order(code: :asc)
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to user_services_path(current_user.id), notice: t(:successfully_created, item: t('services.service')) }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to user_services_path(current_user.id), notice: t(:successfully_updated, item: t('services.service')) }
        format.json { respond_with_bip @service }
      else
        format.html { render :edit }
        format.json { respond_with_bip @service }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to user_services_url(current_user.id), notice: t(:successfully_destroyed, item: t('services.service')) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:code, :description, :vat_id, :unit_id, :price)
    end
end
