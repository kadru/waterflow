# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.5'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'clearance', '~> 2.5'
gem 'csv'
gem 'fx', github: 'kadru/fx', branch: 'support-for-ruby-3'
gem 'honeybadger', '~> 4.0'
gem 'http'
gem 'pagy'
gem 'pg', '>= 0.18', '< 2.0'
gem 'pg_search'
gem 'puma', '~> 5.6'
gem 'rails', '~> 7.0'
gem 'sass-rails', '>= 6'
gem 'sequel', require: false
gem 'sequel_pg', require: false
gem 'shakapacker', '~> 6.0 '
gem 'sidekiq', '~> 6.4'
gem 'skylight'
gem 'slim', '~> 4.0'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'turbolinks', '~> 5'
gem 'view_component', '~> 2.49'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 5'
end

group :development do
  gem 'letter_opener_web'
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 1.18', require: false
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
  gem 'selenium-webdriver', '~> 4.0'
  gem 'shoulda-matchers', '~> 4.2.0'
  gem 'simplecov', require: false
  gem 'webdrivers', '~> 5.0'
  gem 'webmock'
end
