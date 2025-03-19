# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fges
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files

    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    I18n.config.enforce_available_locales = false
    config.i18n.default_locale = :en

    # Autoload libraries in lib folder
    config.autoload_paths << Rails.root.join('lib')

    config.active_job.queue_adapter = :sidekiq

    config.middleware.use Rack::Deflater
  end
end
