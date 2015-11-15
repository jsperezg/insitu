class DeliveryNoteDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_delivery_note_detail, only: [:show, :edit, :update, :destroy]

  # GET /delivery_note_details
  # GET /delivery_note_details.json
  def index
    @delivery_note_details = DeliveryNoteDetail.all
  end

  # GET /delivery_note_details/1
  # GET /delivery_note_details/1.json
  def show
  end

  # GET /delivery_note_details/new
  def new
    @delivery_note_detail = DeliveryNoteDetail.new
  end

  # GET /delivery_note_details/1/edit
  def edit
  end

  # POST /delivery_note_details
  # POST /delivery_note_details.json
  def create
    @delivery_note_detail = DeliveryNoteDetail.new(delivery_note_detail_params)

    respond_to do |format|
      if @delivery_note_detail.save
        format.html { redirect_to @delivery_note_detail, notice: 'Delivery note detail was successfully created.' }
        format.json { render :show, status: :created, location: @delivery_note_detail }
      else
        format.html { render :new }
        format.json { render json: @delivery_note_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_note_details/1
  # PATCH/PUT /delivery_note_details/1.json
  def update
    respond_to do |format|
      if @delivery_note_detail.update(delivery_note_detail_params)
        format.html { redirect_to @delivery_note_detail, notice: 'Delivery note detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @delivery_note_detail }
      else
        format.html { render :edit }
        format.json { render json: @delivery_note_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_note_details/1
  # DELETE /delivery_note_details/1.json
  def destroy
    @delivery_note_detail.destroy
    respond_to do |format|
      format.html { redirect_to delivery_note_details_url, notice: 'Delivery note detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_note_detail
      @delivery_note_detail = DeliveryNoteDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_note_detail_params
      params.require(:delivery_note_detail).permit(:service_id, :quantity, :price, :custom_description)
    end
end
