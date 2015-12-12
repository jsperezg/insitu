class VatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vat, only: [:show, :edit, :update, :destroy]

  # GET /vats
  # GET /vats.json
  def index
    @vats = Vat.all
  end

  # GET /vats/1
  # GET /vats/1.json
  def show
  end

  # GET /vats/new
  def new
    @vat = Vat.new
  end

  # GET /vats/1/edit
  def edit
  end

  # POST /vats
  # POST /vats.json
  def create
    @vat = Vat.new(vat_params)

    respond_to do |format|
      if @vat.save
        format.html { redirect_to user_vats_path(current_user.id), notice: t(:successfully_created, item: t('vats.vat')) }
        format.json { render :show, status: :created, location: @vat }
      else
        format.html { render :new }
        format.json { render json: @vat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vats/1
  # PATCH/PUT /vats/1.json
  def update
    respond_to do |format|
      if @vat.update(vat_params)
        format.html { redirect_to user_vats_path(current_user.id), notice: t(:successfully_updated, item: t('vats.vat')) }
        format.json { respond_with_bip @vat }
      else
        format.html { render :edit }
        format.json { respond_with_bip @vat }
      end
    end
  end

  # DELETE /vats/1
  # DELETE /vats/1.json
  def destroy
    @vat.destroy
    respond_to do |format|
      format.html { redirect_to user_vats_path(current_user.id), notice: t(:successfully_destroyed, item: t('vats.vat')) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vat
      @vat = Vat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vat_params
      params.require(:vat).permit(:label, :rate)
    end
end
