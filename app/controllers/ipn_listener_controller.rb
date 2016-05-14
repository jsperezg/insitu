class IpnListenerController < ApplicationController
  include Paypal

  protect_from_forgery :except => [:create]

  def create
    begin
      response = validate_ipn_notification(request.raw_post)
      case response
        when 'VERIFIED'
          payment = process_paypal_request(params)
          if payment.completed?
            # process payment
          end
        when 'INVALID'
          logger.error "Paypal failed to validate the IPN notification: #{ request.raw_post }"
        else
          raise InvalidResponseError("Invalid response from Paypal server when verifying the IPN: #{ response }")
      end

      render :nothing => true, status: :ok
    rescue InvalidResponseError => e
      logger.error e
      render :nothing => true, status: :unprocessable_entity
    rescue => e
      logger.error e
      # Notify to customer
      render :nothing => true, status: :ok
    end
  end
end
