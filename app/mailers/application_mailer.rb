# frozen_string_literal: true

# Main mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@waterflowapp.com', deliver_later_queue_name: 'default'
  layout 'mailer'
end
