class ApiController < ActionController::Base
  acts_as_token_authentication_handler_for User, fallback: :none

  respond_to :json
end
