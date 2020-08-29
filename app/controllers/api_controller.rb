# frozen_string_literal: true

class ApiController < ActionController::Base
  acts_as_token_authentication_handler_for User, fallback: :none
  before_action :set_locale, :switch_tenant, :store_user

  respond_to :json

  private

  def set_locale
    I18n.locale = if current_user.try(:locale).blank?
                    'en'
                  else
                    current_user.locale
                  end
  rescue StandardError => e
    logger.error "Failed to set locale: #{e}"
  end

  def switch_tenant
    Apartment::Tenant.switch! current_user.try(:tenant) unless Rails.env.test?
  end

  def store_user
    Thread.current[:user] = current_user
  end
end
