# frozen_string_literal: true

# Main mailer
class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_SENDER_EMAIL']
  layout 'mailer'
end
