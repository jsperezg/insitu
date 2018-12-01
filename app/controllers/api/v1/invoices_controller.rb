# frozen_string_literal: true

module Api
  module V1
    class InvoicesController < ApiController
      include Api

      include InvoicingNotifications

      before_action :set_invoice, only: %i[show print update destroy]

      # GET /invoices
      # GET /invoices.json
      def index
        @invoices = Invoice.all
      end

      # GET /invoices/1
      # GET /invoices/1.json
      def show; end

      def print
        if @invoice.created?
          @invoice.invoice_status = InvoiceStatus.sent
          @invoice.save!
        end

        respond_to do |format|
          format.json do
            render 'show'
          end
          format.pdf do
            pdf = InvoicePdf.new current_user, @invoice
            send_data pdf.render, filename: "invoice_#{@invoice.number.tr('/', '_')}.pdf", type: 'application/pdf'
          end
        end
      end

      # POST /invoices
      # POST /invoices.json
      def create
        Invoice.transaction do
          @invoice = Invoice.new(invoice_params)

          @invoice.apply_irpf(current_user)

          if @invoice.save
            render 'show'
          else
            render json: ResponseFactory.get_response_for(@invoice)
          end
        end
      end

      # PATCH/PUT /invoices/1
      # PATCH/PUT /invoices/1.json
      def update
        Invoice.transaction do
          @invoice.apply_irpf(current_user)

          if @invoice.update(invoice_params)
            render 'show'
          else
            render json: ResponseFactory.get_response_for(@invoice)
          end
        end
      end

      # DELETE /invoices/1
      # DELETE /invoices/1.json
      def destroy
        @invoice.destroy
        render json: ResponseFactory.get_response_for(@invoice)
      rescue StandardError => e
        render json: ResponseFactory.error_response(e.message)
      end

      def cancel
        original_invoice = Invoice.find(params[:id])
        service = InvoiceCorrector.new(original_invoice)
        begin
          @invoice = service.cancel
          render json: ResponseFactory.get_response_for(@invoice)
        rescue StandardError => e
          render json: ResponseFactory.error_response(e.message)
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def invoice_params
        params.require(:invoice).permit(
          :date,
          :number,
          :payment_method_id,
          :customer_id,
          :payment_date,
          :paid_on,
          :invoice_status_id,
          invoice_details_attributes: %i[
            id invoice_id service_id vat_rate quantity price
            discount description _destroy
          ]
        )
      end
    end
  end
end
