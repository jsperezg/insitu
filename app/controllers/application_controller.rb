class ApplicationController < ActionController::Base
  before_action :set_locale, :validate_secure_request, :switch_tenant, :store_user
  before_filter :configure_permitted_parameters, if: :devise_controller?

  private

  def set_locale
    begin
      if current_user.try(:locale).blank?
        logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
        I18n.locale = extract_locale_from_headers
        logger.debug "* Locale set to '#{I18n.locale}'"
      else
        I18n.locale = current_user.locale
      end
    rescue => e
      logger.error  "Failed to set locale: #{ e }"
    end
  end

  def extract_locale_from_headers
    if request.env['HTTP_ACCEPT_LANGUAGE'].nil?
      'es'
    else
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(
        :password, :password_confirmation, :current_password,
        :tax_id, :name, :address, :city, :country, :state, :postal_code, :phone_number, :locale
      )
    }
  end

  # If user is trying to access another user account
  def validate_secure_request
    if user_signed_in? and params.key? :user_id
      if current_user.id.to_s != params[:user_id]
        sign_out current_user
      end
    end
  end

  def switch_tenant
    unless Rails.env.test?
      Apartment::Tenant.switch! current_user.try(:tenant)
    end
  end

  def store_user
    Thread.current[:user] = current_user
  end
end
