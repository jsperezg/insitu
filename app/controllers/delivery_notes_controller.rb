class DeliveryNotesController < SecuredController
  before_action :set_delivery_note, only: [:show, :print, :edit, :update, :destroy]

  # GET /delivery_notes
  # GET /delivery_notes.json
  def index
    @delivery_notes = DeliveryNote.order(date: :desc)
  end

  # GET /delivery_notes/1
  # GET /delivery_notes/1.json
  def show
  end

  def print
    render :show, layout: 'print'
  end

  # GET /delivery_notes/new
  def new
    @delivery_note = DeliveryNote.new( date: DateTime.now )
    detail = @delivery_note.delivery_note_details.build
  end

  # GET /delivery_notes/1/edit
  def edit
    @delivery_note_detail = DeliveryNoteDetail.new
    detail = @delivery_note.delivery_note_details.build
  end

  # POST /delivery_notes
  # POST /delivery_notes.json
  def create
    DeliveryNote.transaction do
      @delivery_note = DeliveryNote.new(delivery_note_params)

      respond_to do |format|
        if @delivery_note.save
          format.html { redirect_to edit_user_delivery_note_path(current_user, @delivery_note),
                        notice: t(:successfully_created, item: t('delivery_notes.delivery_note')) }
          format.json { render :show, status: :created, location: @delivery_note }
        else
          format.html { render :new }
          format.json { render json: @delivery_note.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /delivery_notes/1
  # PATCH/PUT /delivery_notes/1.json
  def update
    DeliveryNote.transaction do
      respond_to do |format|
        if @delivery_note.update(delivery_note_params)
          format.html { redirect_to edit_user_delivery_note_path(current_user, @delivery_note),
                        notice: t(:successfully_updated, item: t('delivery_notes.delivery_note')) }
          format.json { render :show, status: :ok, location: @delivery_note }
        else
          format.html { render :edit }
          format.json { render json: @delivery_note.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /delivery_notes/1
  # DELETE /delivery_notes/1.json
  def destroy
    @delivery_note.destroy
    respond_to do |format|
      format.html { redirect_to user_delivery_notes_url(current_user),
                    notice: t(:successfully_destroyed, item: t('delivery_notes.delivery_note')) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_note
      @delivery_note = DeliveryNote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_note_params
      params.require(:delivery_note).permit(
        :number,
        :customer_id,
        :date,
        delivery_note_details_attributes: [
          :id, :delivery_note_id, :service_id, :quantity, :price, :custom_description, :_destroy
        ]
      )
    end
end
