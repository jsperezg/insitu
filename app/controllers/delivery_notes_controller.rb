class DeliveryNotesController < SecuredController
  before_action :set_delivery_note, only: [:show, :print, :forward_email, :edit, :update, :destroy, :invoice]

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
    respond_to do |format|
      format.html do
        render :show, layout: 'print'
      end
      format.pdf do
        render pdf: "delivery_note_#{ @delivery_note.number.gsub('/', '_') }", viewport_size: '1920x1080'
      end
    end
  end

  def forward_email
    if @delivery_note.customer.contact_email.blank?
      flash[:error] = t('helpers.customer_mail_missing')
      redirect_to user_delivery_note_path(current_user.id, @delivery_note.id)
      return
    end

    file_name =  "delivery_note_#{ current_user.id }_#{ @delivery_note.number.gsub('/', '_') }_#{ Time.now.to_i }"
    pdf = render_to_string pdf: file_name, template: 'delivery_notes/print.pdf.erb', encoding: 'UTF-8'

    # then save to a file
    save_path = Rails.root.join('tmp',"#{ file_name }.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end

    DeliveryNoteMailer.send_to_customer(current_user, @delivery_note, save_path.to_s, I18n.locale.to_s).deliver_later
    redirect_to user_delivery_note_path(current_user.id, @delivery_note.id), notice: t('helpers.email_successfully_sent')
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

  def invoice
    payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
    unless payment_method
      flash[:alert] = t('payment_methods.not_found')
      redirect_to edit_user_delivery_note_path(current_user, @delivery_note)
      return
    end

    Invoice.transaction do
      invoice = Invoice.create(
          date: Date.today,
          payment_date: Date.today + 15.days,
          customer_id: @delivery_note.customer_id,
          payment_method_id: PaymentMethod.first.id
      )

      # Iterate over estimate details.
      details = DeliveryNoteDetail.where(delivery_note_id: @delivery_note.id, invoice_detail_id: nil)
      details.each do |detail|
        invoice_detail = InvoiceDetail.create(
            invoice_id: invoice.id,
            service_id: detail.service_id,
            vat_rate: detail.service.vat.rate,
            price: detail.price,
            discount: 0,
            description: detail.custom_description,
            quantity: detail.quantity
        )

        detail.invoice_detail_id = invoice_detail.id
        detail.save
      end

      if invoice.invoice_details.empty?
        flash[:alert] = t('delivery_notes.nothing_to_invoice')
        redirect_to edit_user_delivery_note_path(current_user, @delivery_note)
        raise ActiveRecord::Rollback
      else
        redirect_to edit_user_invoice_path(current_user, invoice)
      end
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
