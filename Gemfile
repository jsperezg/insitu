source 'https://rubygems.org'

ruby '2.3.3'

gem 'apartment'
gem 'apartment-sidekiq'
gem 'best_in_place', '~> 3.0.1'
gem 'bootstrap-filestyle-rails'
gem 'ckeditor_rails'
gem 'cookies_eu'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'currencies', :require => 'iso4217'
gem 'dalli', group: :production
gem 'devise'
gem 'email_validator'
gem 'figaro'
gem 'filterrific'
gem 'sidekiq'
gem 'sidekiq-client-cli'
gem 'twitter-bootstrap-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#TODO: Replace with rails 5.0.3 as soon as it becomes stable.
# gem 'rails', '5.0.2'
gem 'rails', github: 'rails/rails', branch: '5-0-stable'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.4.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'jquery-ui-rails'
gem 'knockoutjs-rails'
gem 'will_paginate-bootstrap'

gem 'prawn'
gem 'prawn-table'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0.0'
gem 'nprogress-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem  'yajl-ruby'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'jquery-turbolinks'
gem 'data-confirm-modal'
gem 'pdfjs_rails'

# JSON API -> Android / IOS integration
gem 'simple_token_authentication', '~> 1.0'
gem 'rack-cors', :require => 'rack/cors'

gem 'omniauth-google-oauth2'
gem 'smarter_csv'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'web-console', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'

  # Deployment with capistrano
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-figaro-yml', '~> 1.0.2'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'

  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'rails-controller-testing', require: false
  gem 'rspec-rails', '~> 3.5gem'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'rspec-sidekiq'
  gem 'simplecov', require: false
end
