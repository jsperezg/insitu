# frozen_string_literal: true

module Api
  module V1
    class EstimatesController < ApiController
      include Api

      before_action :set_estimate, only: %i[show print update destroy invoice]

      # GET /estimates
      # GET /estimates.json
      def index
        @estimates = Estimate.all
      end

      # GET /estimates/1/print
      def print
        @estimate.sent!

        respond_to do |format|
          format.json do
            render 'show'
          end
          format.pdf do
            pdf = EstimatePdf.new current_user, @estimate
            send_data pdf.render, filename: "estimate_#{@estimate.number.tr('/', '_')}.pdf", type: 'application/pdf'
          end
        end
      end

      # POST /estimates
      # POST /estimates.json
      def create
        Estimate.transaction do
          @estimate = Estimate.new(estimate_params)
          if @estimate.save
            render 'show'
          else
            render json: ResponseFactory.get_response_for(@estimate)
          end
        end
      end

      # PATCH/PUT /estimates/1
      # PATCH/PUT /estimates/1.json
      def update
        Estimate.transaction do
          if @estimate.update(estimate_params)
            render 'show'
          else
            render json: ResponseFactory.get_response_for(@estimate)
          end
        end
      end

      # DELETE /estimates/1
      # DELETE /estimates/1.json
      def destroy
        @estimate.destroy
        render json: ResponseFactory.get_response_for(@estimate)
      end

      def invoice
        payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
        unless payment_method
          render json: ResponseFactory.error_response(t('payment_methods.not_found'))
          return
        end

        Invoice.transaction do
          unless @estimate.accepted?
            @estimate.estimate_status = EstimateStatus.find_by(name: 'estimate_status.accepted')
            @estimate.save
          end

          invoice = Invoice.create(
            date: Date.today,
            payment_date: Date.today + 15.days,
            customer_id: @estimate.customer_id,
            payment_method_id: payment_method.id
          )

          invoice.apply_irpf(current_user)
          invoice.save!

          # Iterate over estimate details.
          details = EstimateDetail.where(estimate_id: @estimate.id, invoice_detail_id: nil)
          details.each do |detail|
            invoice_detail = InvoiceDetail.create(
              invoice_id: invoice.id,
              service_id: detail.service_id,
              vat_rate: detail.service.vat.rate,
              price: detail.price,
              discount: detail.discount,
              description: detail.description,
              quantity: detail.quantity
            )

            detail.invoice_detail_id = invoice_detail.id
            detail.save
          end

          if invoice.invoice_details.empty?
            render json: ResponseFactory.error_response(t('estimates.nothing_to_invoice'))
            raise ActiveRecord::Rollback
          else
            render json: ResponseFactory.get_response_for(invoice)
          end
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_estimate
        @estimate = Estimate.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def estimate_params
        params.require(:estimate).permit(
          :date,
          :number,
          :customer_id,
          :valid_until,
          :estimate_status_id,
          estimate_details_attributes: %i[
            id estimate_id service_id quantity price
            discount description _destroy
          ]
        )
      end
    end
  end
end
