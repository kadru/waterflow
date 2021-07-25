# frozen_string_literal: true

Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = ENV.fetch('DEFAULT_SENDER_EMAIL', 'noreply@waterflowapp.com')
  config.rotate_csrf_on_sign_in = true
  config.signed_cookie = true
end
