class ApplicationController < ActionController::Base
  before_action :set_locale, :switch_tenant
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_locale
    begin
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      I18n.locale = extract_locale_from_accept_language_header
      logger.debug "* Locale set to '#{I18n.locale}'"
    rescue => e
      logger.error  "Failed to set locale: #{ e }"

    end
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(
        :password, :password_confirmation, :current_password,
        :tax_id, :name, :address, :city, :country, :state, :postal_code
      )
    }
  end

  def switch_tenant
    unless Rails.env.test?
      Apartment::Tenant.switch! current_user.try(:tenant)
    end
  end
end
