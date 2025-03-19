# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0', '>= 6.0.6.1'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', '~> 0.6.4'

# Reduces boot times through caching; configured in config/boot.rb
gem 'bootsnap', require: false

gem 'bootstrap-filestyle-rails'
gem 'cancancan', '~> 2.0'
gem 'chartkick'
gem 'ckeditor_rails'
gem 'cookies_eu'
gem 'country_select', '~> 5.1'
gem 'currencies', require: 'iso4217'
gem 'dalli', group: :production
gem 'data-confirm-modal'
gem 'devise', '~> 4.7.1'
gem 'email_validator'
gem 'figaro'
gem 'filterrific', '~> 5.2.1'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'knockoutjs-rails'
gem 'mimemagic', '~> 0.3.10'
gem 'multi_json', '~> 1.15'
gem 'nprogress-rails'
gem 'paperclip', '~> 6.1.0'
gem 'pdfjs_rails'
gem 'prawn'
gem 'prawn-table'
gem 'rack-cors', require: 'rack/cors'
gem 'rectify'
gem 'ros-apartment', require: 'apartment'
gem 'ros-apartment-sidekiq', '~> 1.2'
gem 'sidekiq'
gem 'sidekiq-client-cli'
gem 'simple_token_authentication', '~> 1.0'
gem 'smarter_csv'
gem 'turbolinks', '~> 5.0.0'
gem 'twitter-bootstrap-rails'
gem 'will_paginate-bootstrap'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'yajl-ruby'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 2.6', '>= 2.6.1', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development do
  gem 'bundler-audit'

  gem 'capistrano', '~> 3.9'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-figaro-yml', '~> 1.0.2'
  gem 'capistrano-linked-files'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.1'
  gem 'rspec-sidekiq'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
