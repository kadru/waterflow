# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'bugsnag', '~> 6.21'
gem 'clearance'
gem 'csv'
gem 'exception_notification'
gem 'http'
gem 'pagy'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.3'
gem 'rails', '~> 6.1.0'
gem 'sass-rails', '>= 6'
gem 'sequel', require: false
gem 'sequel_pg', require: false
gem 'sidekiq', '~> 6.0'
gem 'slim', '~> 4.0.1'
gem 'turbolinks', '~> 5'
gem 'view_component', require: 'view_component/engine'
gem 'webpacker', '~> 4.0'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 4.0'
end

group :development do
  gem 'letter_opener_web'
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 0.79.0', require: false
  # gem 'solargraph'
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '~> 3.30'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails'
  # gem 'rspec-benchmark'
  gem 'selenium-webdriver', '~> 3.142.7'
  gem 'shoulda-matchers', '~> 4.2.0'
  gem 'simplecov', require: false
  gem 'webdrivers', '~> 4.0'
  gem 'webmock'
end
