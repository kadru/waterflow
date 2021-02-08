Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = ENV['DEFAULT_SENDER_EMAIL']
  config.rotate_csrf_on_sign_in = true
end
