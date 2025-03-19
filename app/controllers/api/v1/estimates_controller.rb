# frozen_string_literal: true

module Api
  module V1
    class EstimatesController < ApiController
      before_action :set_estimate, only: %i[show print update destroy invoice]

      # GET /estimates
      # GET /estimates.json
      def index
        @estimates = Estimate.all
      end

      def show; end

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
            render json: get_response_for(@estimate)
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
            render json: get_response_for(@estimate)
          end
        end
      end

      # DELETE /estimates/1
      # DELETE /estimates/1.json
      def destroy
        @estimate.destroy
        render json: get_response_for(@estimate)
      end

      def invoice
        invoice = InvoiceService.call(@estimate, current_user)
        render json: get_response_for(invoice)
      rescue NothingToInvoiceException
        render json: error_response(I18n.t('estimates.nothing_to_invoice'))
      rescue StandardError => e
        render json: error_response(e)
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
