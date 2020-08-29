# frozen_string_literal: true

module Api
  module V1
    class InvoiceStatusesController < ApiController
      include Api

      before_action :set_invoice_status, only: [:show]

      def index
        @invoice_statuses = InvoiceStatus.all
      end

      def show; end

      private

      def set_invoice_status
        @invoice_status = InvoiceStatus.find(params[:id])
      end
    end
  end
end
