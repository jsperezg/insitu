class IpnListenerController < ApplicationController
  include Paypal

  protect_from_forgery :except => [:create]

  def create
    status = :ok

    begin
      response = validate_ipn_notification(request.raw_post)
      case response
        when 'VERIFIED'
          payment = process_paypal_request(params)
          if payment.completed?
            RenewSubscriptionJob.perform_now payment.id
          end
        when 'INVALID'
          logger.error "Paypal failed to validate the IPN notification: #{ request.raw_post }"
        else
          raise InvalidResponseError.new("Invalid response from Paypal server when verifying the IPN: #{ response }")
      end
    rescue InvalidResponseError => e
      logger.error "IPN Request failed: #{e}"

      status = :unprocessable_entity
    rescue => e
      logger.error e
    end

    render :nothing => true, status: status
  end
end
