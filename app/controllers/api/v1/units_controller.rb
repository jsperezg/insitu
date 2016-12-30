class Api::V1::UnitsController < ApiController
  include Api

  before_action :set_unit, only: [:show, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
  end

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@unit)
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    if @unit.update(unit_params)
      render 'show'
    else
      render json: ResponseFactory.get_response_for(@unit)
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    render json: ResponseFactory.get_response_for(@unit)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_unit
    @unit = Unit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def unit_params
    params.require(:unit).permit(:label_short, :label_long)
  end
end
