# frozen_string_literal: true

require 'exception_notification/rails'

require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound,
  # AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |_exception, _options|
    !Rails.env.production?
  end

  # Ignore exceptions generated by crawlers
  # config.ignore_crawlers %w{Googlebot bingbot}

  # Notifiers =================================================================

  # Email notifier sends notifications by email.

  config.add_notifier(
    :email,
    email_prefix: '[ERROR] waterflow app',
    # sender_address: %("Notifier" #{ENV['WORKER_SENDER_ERROR_EMAIL']}),
    # exception_recipients: ENV['WORKER_RECIPIENT_ERROR_EMAIL'],
    sender_address: %("Notifier" errors@waterflowapp.com),
    exception_recipients: 'orivas155@gmail.com'
  )
  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   subdomain: 'my_subdomain',
  #   token: 'my_token',
  #   room_name: 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   api_token: 'my_token',
  #   room_name: 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   url: 'http://example.com:5555/hubot/path',
  #   http_method: :post
  # }
end
