class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user

  respond_to :json

  # This controller provides a JSON version of the Devise::SessionsController and
  # is compatible with the use of SimpleTokenAuthentication.
  # See https://github.com/gonzalo-bulnes/simple_token_authentication/issues/27

  def create
    # Fetch params
    email = params[:session][:email] if params[:session]
    password = params[:session][:password] if params[:session]

    # Validations
    if request.format != :json
      render status: 406, json: { message: 'The request must be JSON.' }
      return
    end

    if email.blank? or password.blank?
      render status: 400, json: { message: 'The request MUST contain the user email and password.' }
      return
    end

    # Authentication
    user = User.find_by(email: email)

    if user
      if user.valid_password? password
        user.restore_authentication_token!

        user.sign_in_count += 1
        user.last_sign_in_at = user.current_sign_in_at
        user.last_sign_in_ip =  user.current_sign_in_ip

        user.current_sign_in_at = DateTime.now
        user.current_sign_in_ip = request.remote_ip

        if user.save
          # Note that the data which should be returned depends heavily of the API client needs.
          render status: 200, json: {
              email: user.email,
              authentication_token: user.authentication_token,
              id: user.id,
              tax_id: user.tax_id,
              name: user.name,
              address: user.address,
              city: user.city,
              state: user.state,
              country: user.country,
              locale: user.locale,
              phone_number: user.phone_number,
              valid_until: user.valid_until,
              banned: user.banned,
              currency: user.currency
          }
        else
          render status: 500, json: { error: user.errors.messages }
        end
      else
        render status: 401, json: { message: 'Invalid email or password.' }
      end
    else
      render status: 401, json: { message: 'Invalid email or password.' }
    end
  end

  def destroy
    if params[:user_token].blank?
      render status: 404, json: { message: 'Invalid token.' }
      return
    end

    # Fetch params
    user = User.find_by(authentication_token: params[:user_token])
    if user.nil?
      render status: 404, json: { message: 'Invalid token.' }
    else
      user.update_attribute(:authentication_token, nil)
      render status: 200, json: { message: 'logout successful'}
    end
  end
end

