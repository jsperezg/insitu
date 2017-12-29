# frozen_string_literal: true

# Controller for unit related actions
class UnitsController < SecuredController
  before_action :set_unit, only: %i[show edit update destroy]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
  end

  # GET /units/1
  # GET /units/1.json
  def show; end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit; end

  # POST /units
  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to user_units_path(current_user.id), notice: t(:successfully_created, item: t('units.unit'))
    else
      render :new
    end
  end

  # PATCH/PUT /units/1
  def update
    if @unit.update(unit_params)
      redirect_to user_units_path(current_user.id), notice: t(:successfully_updated, item: t('units.unit'))
    else
      render :edit
    end
  end

  # DELETE /units/1
  def destroy
    if @unit.destroy
      redirect_to user_units_path(current_user.id), notice: t(:successfully_destroyed, item: t('units.unit'))
    else
      redirect_to user_units_path(current_user.id), alert: @unit.errors.full_messages.join('<br>')
    end
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
