# frozen_string_literal: true

module Api
  module V1
    # TODO: Revamp this controller to use the new API
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_signed_out_user

      before_action :check_request_format

      respond_to :json

      # This controller provides a JSON version of the Devise::SessionsController and
      # is compatible with the use of SimpleTokenAuthentication.
      # See https://github.com/gonzalo-bulnes/simple_token_authentication/issues/27

      def create
        # Fetch params
        email = params.dig(:session, :email)
        password = params.dig(:session, :password)

        if email.blank? || password.blank?
          render status: :bad_request, json: { message: 'The request MUST contain the user email and password.' }
          return
        end

        # Authentication
        user = User.find_by(email: email)
        unless user&.valid_password?(password)
          render status: :unauthorized, json: { message: 'Invalid email or password.' }
          return
        end

        track_user_sign_in(user)
        render status: :ok, json: sign_in_response_for(user: user)
      end

      def destroy
        if params[:user_token].blank?
          render status: :not_found, json: { message: 'Invalid token.' }
          return
        end

        # Fetch params
        user = User.find_by(authentication_token: params[:user_token])
        if user.nil?
          render status: :not_found, json: { message: 'Invalid token.' }
        else
          user.update(authentication_token: nil)
          render status: :ok, json: { message: 'logout successful' }
        end
      end

      private

      def track_user_sign_in(user)
        user.restore_authentication_token!

        user.sign_in_count += 1
        user.last_sign_in_at = user.current_sign_in_at
        user.last_sign_in_ip = user.current_sign_in_ip

        user.current_sign_in_at = Time.zone.now
        user.current_sign_in_ip = request.remote_ip
        user.save!
      end

      def check_request_format
        return if request.format == :json

        render status: :not_acceptable, json: { message: 'The request must be JSON.' }
      end

      def sign_in_response_for(user:)
        {
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
      end
    end
  end
end
