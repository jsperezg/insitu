class ApiController < RocketPants::Base
  jsonp

  acts_as_token_authentication_handler_for User, fallback: :none
end
