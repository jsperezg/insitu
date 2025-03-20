# frozen_string_literal: true

module PaypalTestHelper
  def paypal_renewal_request(user)
    request = attributes_for(:payment, user_id: user.id, payer_email: user.email)

    request[:custom] = request[:user_id]
    request[:item_number] = request[:plan_id]

    request
  end
end

RSpec.configure do |_config|
  include PaypalTestHelper
end
