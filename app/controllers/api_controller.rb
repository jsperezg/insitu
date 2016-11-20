class ApiController < ActionController::Base
  before_action :set_locale, :switch_tenant, :store_user

  acts_as_token_authentication_handler_for User, fallback: :none

  respond_to :json

  private

  def set_locale
    begin
      if current_user.try(:locale).blank?
        I18n.locale = 'en'
      else
        I18n.locale = current_user.locale
      end
    rescue => e
      logger.error  "Failed to set locale: #{ e }"
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
