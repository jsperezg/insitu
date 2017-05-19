source 'https://rubygems.org'

ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2', '>= 4.2.6'
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

gem 'devise', '3.5.2'
gem 'devise-async'
gem 'apartment'
gem 'twitter-bootstrap-rails'
gem 'email_validator'
gem 'best_in_place', '~> 3.0.1'
gem 'jquery-ui-rails'
gem 'knockoutjs-rails'
gem 'will_paginate-bootstrap'
gem 'bootstrap-filestyle-rails'
gem 'ckeditor_rails'
gem 'prawn'
gem 'prawn-table'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'currencies', :require => 'iso4217'

gem 'sidekiq'
gem 'apartment-sidekiq'
gem 'sidekiq-client-cli'
gem 'figaro'
gem 'filterrific'

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
gem 'cookies_eu'
gem 'data-confirm-modal'
gem 'pdfjs_rails'

# JSON API -> Android / IOS integration
gem 'simple_token_authentication', '~> 1.0'
gem 'rack-cors', :require => 'rack/cors'

gem 'omniauth-google-oauth2'
gem 'smarter_csv'
gem 'dalli', group: :production

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Access an IRB console on exception pages or by using <%= console %> in views
gem 'web-console', '~> 2.0', group: :development

# Deployment with capistrano
gem 'capistrano', '~> 3.4', group: :development
gem 'capistrano-figaro-yml', '~> 1.0.2', group: :development
gem 'capistrano-rbenv', '~> 2.0', group: :development
gem 'capistrano-bundler', '~> 1.1.2', group: :development
gem 'capistrano-rails', '~> 1.1', group: :development
gem 'capistrano-passenger', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails',  '~> 4.0'
  gem 'rspec-sidekiq'
  gem 'faker'
end

group :test do
  gem 'simplecov', require: false
end
