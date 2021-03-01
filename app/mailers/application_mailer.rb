# frozen_string_literal: true

# Main mailer
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_SENDER_EMAIL', 'noreply@waterflowapp.com')
  layout 'mailer'
end
