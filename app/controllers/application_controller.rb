# frozen_string_literal: true

# Base controller for all controllers in the app
class ApplicationController < ActionController::Base
  before_action :set_locale, :validate_secure_request, :switch_tenant, :store_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :save_previous_url

  private

  def set_locale
    I18n.locale = if current_user&.locale.blank?
                    extract_locale_from_headers
                  else
                    current_user.locale
                  end
  rescue StandardError => e
    logger.error "Failed to set locale: #{e}"
  end

  def extract_locale_from_headers
    if request.env['HTTP_ACCEPT_LANGUAGE'].nil?
      'es'
    else
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :password, :password_confirmation, :current_password,
        :tax_id, :name, :address, :city, :country, :state, :postal_code,
        :phone_number, :locale, :currency, :logo
      )
    end

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :terms_of_service)
    end
  end

  # If user is trying to access another user account
  def validate_secure_request
    if user_signed_in? && params.key?(:user_id)
      if current_user.id.to_s != params[:user_id]
        sign_out current_user
      end
    end
  end

  def switch_tenant
    return if Rails.env.test?
    Apartment::Tenant.switch! current_user&.tenant
  end

  def store_user
    Thread.current[:user] = current_user
  end

  def save_previous_url
    session[:previous_url] = URI(request.referer || '').path
  end
end
