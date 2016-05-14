module Paypal
  include LocaleTools

  class InvalidResponseError < StandardError; end

  def validate_ipn_notification(raw)
    uri = URI.parse(Rails.configuration.x.paypal_validate_ipn_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = Rails.configuration.x.paypal_validate_ipn_verify_mode
    http.use_ssl = true
    http.post(uri.request_uri, raw, 'Content-Length' => "#{raw.size}", 'User-Agent' => Rails.configuration.x.paypal_validate_ipn_user_agent).body
  end

  def process_paypal_request(params)
    payment = Payment.find_by(txn_id: params[:txn_id])
    if payment.nil?
      payment = create_payment(params)
    else
      update_payment(payment, params)
    end

    unless payment.save
      raise payment.errors.full_messages.join(', ')
    end
  end

  def create_payment(params)
    payment = Payment.new
    apply_params(payment, params)

    payment
  end

  def update_payment(payment, params)
    if payment.payment_status == params[:payment_status]
      raise 'Repeated request: Another request with the same id and status is already registered.'
    end

    apply_params(payment, params)
  end

  def apply_params(payment, params)
    # Apply parameters that don't require any transformation.
    [ :txn_id, :business, :receiver_email, :receiver_id, :residence_country, :payer_id, :payer_email, :payer_status, :last_name, :first_name,
      :payment_status, :payment_type, :txn_type, :mc_gross, :tax, :mc_fee, :quantity, :mc_currency, :charset, :notify_version ].each do |param|
      payment[param] = params[param]
    end

    payment.user = User.find(params[:custom])
    payment.plan = Plan.find(params[:item_number])

    with_locale(:en) do
      payment.payment_date = DateTime.parse(params[:payment_date]).new_offset(0)
    end
  end


end