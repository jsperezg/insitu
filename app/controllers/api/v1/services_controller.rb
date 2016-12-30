class Api::V1::ServicesController < ApiController
  include Api

  before_action :set_service, only: [:show, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.order(description: :asc)
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    if @service.save
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@service)
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    if @service.update(service_params)
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@service)
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    render json: ResponseFactory.get_response_for(@service)
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
