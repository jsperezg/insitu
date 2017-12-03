# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local       = true

  # Enable caching
  config.action_controller.perform_caching = true
  config.cache_store = :memory_store, { size: 64.megabytes }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all
  # assets yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.logger = Logger.new 'log/ActionMailer.log'
  config.action_mailer.logger.level = Logger::DEBUG

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'mail.your-server.de',
    port: 587,
    domain: 'insitu.tools',
    user_name: ENV['mail_username'],
    password: ENV['mail_password'],
    authentication: :plain,
    enable_starttls_auto: true
  }

  Rails.application.routes.default_url_options[:host] = 'localhost:3000'

  # Paypal integration
  config.x.paypal_validate_ipn_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate'
  config.x.paypal_validate_ipn_verify_mode = OpenSSL::SSL::VERIFY_NONE
  config.x.paypal_validate_ipn_user_agent = 'Insitu development'
  config.x.paypal_receiver_email = 'jsperezg_facilitator@gmail.com'
  config.x.paypal_billing_account = 'jsperezg@gmail.com'
end
