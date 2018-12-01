# frozen_string_literal: true

module Api
  module V1
    class DeliveryNotesController < ApiController
      include Api

      before_action :set_delivery_note, only: %i[show print update destroy invoice]

      # GET /delivery_notes
      # GET /delivery_notes.json
      def index
        @delivery_notes = DeliveryNote.all
      end

      # GET /delivery_notes/1
      # GET /delivery_notes/1.json
      def show; end

      def print
        respond_to do |format|
          format.json do
            render 'show'
          end
          format.pdf do
            pdf = DeliveryNotePdf.new current_user, @delivery_note
            send_data pdf.render, filename: "delivery_note_#{@delivery_note.number.tr('/', '_')}.pdf", type: 'application/pdf'
          end
        end
      end

      # POST /delivery_notes
      # POST /delivery_notes.json
      def create
        DeliveryNote.transaction do
          @delivery_note = DeliveryNote.new(delivery_note_params)
          if @delivery_note.save
            render 'show'
          else
            render json: ResponseFactory.get_response_for(@delivery_note)
          end
        end
      end

      # PATCH/PUT /delivery_notes/1
      # PATCH/PUT /delivery_notes/1.json
      def update
        DeliveryNote.transaction do
          if @delivery_note.update(delivery_note_params)
            render 'show'
          else
            render json: ResponseFactory.get_response_for(@delivery_note)
          end
        end
      end

      # DELETE /delivery_notes/1
      # DELETE /delivery_notes/1.json
      def destroy
        @delivery_note.destroy
        render json: ResponseFactory.get_response_for(@delivery_note)
      end

      def invoice
        payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
        unless payment_method
          render json: ResponseFactory.error_response(t('payment_methods.not_found'))
          return
        end

        Invoice.transaction do
          invoice = Invoice.create(
            date: Date.today,
            payment_date: Date.today + 15.days,
            customer_id: @delivery_note.customer_id,
            payment_method_id: PaymentMethod.first.id
          )

          invoice.apply_irpf(current_user)

          # Iterate over estimate details.
          details = DeliveryNoteDetail.where(delivery_note_id: @delivery_note.id, invoice_detail_id: nil)
          details.each do |detail|
            invoice_detail = InvoiceDetail.create(
              invoice_id: invoice.id,
              service_id: detail.service_id,
              vat_rate: detail.service.vat.rate,
              price: detail.price,
              discount: 0,
              description: detail.description,
              quantity: detail.quantity
            )

            detail.invoice_detail_id = invoice_detail.id
            detail.save
          end

          if invoice.invoice_details.empty?
            render json: ResponseFactory.error_response(t('delivery_notes.nothing_to_invoice'))
            raise ActiveRecord::Rollback
          else
            render json: ResponseFactory.get_response_for(invoice)
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
          delivery_note_details_attributes: %i[
            id delivery_note_id service_id quantity price description _destroy
          ]
        )
      end
    end
  end
end
