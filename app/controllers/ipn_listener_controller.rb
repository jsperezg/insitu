class IpnListenerController < ApplicationController
  include Paypal

  protect_from_forgery :except => [:create]

  def create
    begin
      response = validate_ipn_notification(request.raw_post)
      case response
        when 'VERIFIED'
          validate_receiver_email(params['receiver_email'])
          # check that paymentStatus=Completed
          # check that txnId has not been previously processed
          # check that paymentAmount/paymentCurrency are correct
          # process payment
        when 'INVALID'
          logger.error "Paypal failed to validate the IPN notification: #{ request.raw_post }"
        else
          raise "Invalid response from Paypal server when verifying the IPN: #{ response }"
      end

      render :nothing => true, status: :ok
    rescue => e
      logger.error e
      render :nothing => true, status: :unprocessable_entity
    end
  end

  protected

  def validate_ipn_notification(raw)
    uri = URI.parse(Rails.configuration.x.paypal_validate_ipn_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = Rails.configuration.x.paypal_validate_ipn_verify_mode
    http.use_ssl = true
    http.post(uri.request_uri, raw, 'Content-Length' => "#{raw.size}", 'User-Agent' => Rails.configuration.x.paypal_validate_ipn_user_agent).body
  end

  def validate_receiver_email(receiver_email)
    unless receiver_email == Rails.configuration.x.paypal_receiver_email
      raise "Receiver email #{ receiver_email } is not allowed"
    end
  end
end
