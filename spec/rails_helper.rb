# frozen_string_literal: true

require 'spec_helper'
# require 'webdrivers/geckodriver'
# require 'selenium-webdriver'
require 'capybara/rspec'
require 'sidekiq/testing'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Sidekiq::Testing.inline!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods

  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_firefox
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
