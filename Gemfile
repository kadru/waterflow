# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'clearance'
gem 'csv'
gem 'exception_notification'
gem 'http'
gem 'pagy'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.2', '>= 6.0.3.2'
gem 'sass-rails', '>= 6'
gem 'sidekiq', '~> 6.0.4'
gem 'sidekiq-cron', '~> 1.0'
gem 'slim', '~> 4.0.1'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '3.9.0'
end

group :development do
  gem 'letter_opener_web'
  gem 'listen', '>= 3.0.5', '< 3.2'
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
  gem 'rspec-benchmark'
  gem 'selenium-webdriver', '~> 3.142.7'
  gem 'shoulda-matchers', '~> 4.2.0'
  gem 'simplecov', require: false
  gem 'webdrivers', '~> 4.0'
  gem 'webmock'
end
