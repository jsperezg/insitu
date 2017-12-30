class Api::V1::VatsController < ApiController
  include Api

  before_action :set_vat, only: [:show, :update, :destroy]

  # GET /vats
  # GET /vats.json
  def index
    @vats = Vat.all
  end

  # GET /vats/1
  # GET /vats/1.json
  def show
  end


  # POST /vats
  # POST /vats.json
  def create
    @vat = Vat.new(vat_params)
    if @vat.save
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@vat)
    end
  end

  # PATCH/PUT /vats/1
  # PATCH/PUT /vats/1.json
  def update
    if @vat.update(vat_params)
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@vat)
    end
  end

  # DELETE /vats/1
  # DELETE /vats/1.json
  def destroy
    @vat.destroy
    render json: ResponseFactory.get_response_for(@vat)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vat
    @vat = Vat.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def vat_params
    params.require(:vat).permit(:rate, :default)
  end
end
