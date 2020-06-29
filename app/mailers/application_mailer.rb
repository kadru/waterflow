# frozen_string_literal: true

# Main mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@waterflowapp.com'
  layout 'mailer'
end
