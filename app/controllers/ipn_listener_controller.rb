class IpnListenerController < ApplicationController
  include Paypal

  protect_from_forgery :except => [:create]

  def create
    # Parameters: {"mc_gross"=>"6.05", "protection_eligibility"=>"Ineligible", "payer_id"=>"2E8UEHL748ALL", "tax"=>"1.05", "payment_date"=>"02:24:10 May 08, 2016 PDT", "payment_status"=>"Completed", "charset"=>"windows-1252", "first_name"=>"test", "mc_fee"=>"0.56", "notify_version"=>"3.8", "custom"=>"2", "payer_status"=>"verified", "business"=>"jsperezg_facilitator@gmail.com", "quantity"=>"1", "verify_sign"=>"AcFHC8-bPIDZ88ii3yYZm66tFJ6VAN2wnIFytDXpt8OuR7yjaGKUekws", "payer_email"=>"jsperezg-buyer@gmail.com", "txn_id"=>"1KW388315P8523947", "payment_type"=>"instant", "last_name"=>"buyer", "receiver_email"=>"jsperezg_facilitator@gmail.com", "payment_fee"=>"", "receiver_id"=>"RYG2VVDDN76XA", "txn_type"=>"web_accept", "item_name"=>"Renovar por 1 mes", "mc_currency"=>"EUR", "item_number"=>"1", "residence_country"=>"ES", "test_ipn"=>"1", "handling_amount"=>"0.00", "transaction_subject"=>"", "payment_gross"=>"", "shipping"=>"0.00", "ipn_track_id"=>"36de2a4bc2691"}

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
