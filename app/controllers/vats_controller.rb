# frozen_string_literal: true

# VAT rates controller
class VatsController < SecuredController
  before_action :set_vat, only: %i[show edit update destroy]

  # GET /vats
  # GET /vats.json
  def index
    @vats = Vat.all
  end

  # GET /vats/1
  # GET /vats/1.json
  def show; end

  # GET /vats/new
  def new
    @vat = Vat.new
  end

  # GET /vats/1/edit
  def edit; end

  # POST /vats
  def create
    @vat = Vat.new(vat_params)

    if @vat.save
      redirect_to user_vats_path(current_user.id), notice: t(:successfully_created, item: t('vats.vat'))
    else
      render :new
    end
  end

  # PATCH/PUT /vats/1
  def update
    if @vat.update(vat_params)
      redirect_to user_vats_path(current_user.id), notice: t(:successfully_updated, item: t('vats.vat'))
    else
      render :edit
    end
  end

  # DELETE /vats/1
  def destroy
    @vat.destroy
    redirect_to user_vats_path(current_user.id), notice: t(:successfully_destroyed, item: t('vats.vat'))
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
