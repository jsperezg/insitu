# frozen_string_literal: true

module Api
  module V1
    class CustomersController < ApiController
      include Api

      before_action :set_customer, only: %i[show update destroy]

      def index
        @customers = Customer.with_name(params[:name]).order(name: :asc)
      end

      def show; end

      def create
        @customer = Customer.new(customer_params)
        if @customer.save
          render 'show'
        else
          render json: ResponseFactory.get_response_for(@customer)
        end
      end

      def update
        if @customer.update(customer_params)
          render 'show'
        else
          render json: ResponseFactory.get_response_for(@customer)
        end
      end

      def destroy
        @customer.destroy
        render json: ResponseFactory.get_response_for(@customer)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_customer
        @customer = Customer.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def customer_params
        params
          .require(:customer)
          .permit(
            :name, :tax_id, :billing_serie, :irpf, :contact_name, :contact_phone, :contact_email,
            :address, :city, :country, :state, :postal_code, :send_invoices_to
          )
      end
    end
  end
end
