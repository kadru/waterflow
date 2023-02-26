# frozen_string_literal: true

require 'rails_helper'
require 'support/system/clearance_helpers'

RSpec.feature 'Visitor resets password', type: :system, js: true do
  before do
    ActionMailer::Base.deliveries.clear
    # BUG
    # ActionMailer::Base.deliveries array doesn't fill when perfom_later method is called on mailers
    # the below code fixes it, see https://github.com/rails/rails/issues/37270
    (ActiveJob::Base.descendants << ActiveJob::Base).each(&:disable_test_adapter)
    # Maybe move this to config.before(:suite)
  end

  # TODO
  # https://github.com/rails/rails/issues/37270
  # Until the previously bug is resolved uncomment this code
  # around do |example|
  #   original_adapter = ActiveJob::Base.queue_adapter
  #   ActiveJob::Base.queue_adapter = :inline
  #   example.run
  #   ActiveJob::Base.queue_adapter = original_adapter
  # end

  scenario 'by navigating to the page' do
    visit sign_in_path

    click_link I18n.t('sessions.new.forgot_password')

    expect(current_path).to eq new_password_path
  end

  scenario 'with valid email' do
    user = user_with_reset_password

    expect_page_to_display_change_password_message
    expect_reset_notification_to_be_sent_to user
  end

  scenario 'with non-user account' do
    reset_password_for 'unknown.email@example.com'

    expect_page_to_display_change_password_message
    expect_mailer_to_have_no_deliveries
  end

  private

  def expect_reset_notification_to_be_sent_to(user)
    expect(user.confirmation_token).not_to be_blank
    expect_mailer_to_have_delivery(
      recipient: user.email,
      subject: I18n.t('clearance.models.clearance_mailer.change_password'),
      body: user.confirmation_token
    )
  end

  def expect_page_to_display_change_password_message
    expect(page).to have_content I18n.t('passwords.create.description')
  end

  def expect_mailer_to_have_delivery(recipient:, subject:, body:)
    expect(ActionMailer::Base.deliveries).not_to be_empty

    message = deliveries_email?(recipient:, subject:, body:)

    expect(message).to be
  end

  def expect_mailer_to_have_no_deliveries
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  def deliveries_email?(recipient:, subject:, body:)
    ActionMailer::Base.deliveries.any? do |email|
      email.to.include?(recipient) &&
        email.subject =~ /#{subject}/i &&
        email.html_part.body =~ /#{body}/ &&
        email.text_part.body =~ /#{body}/
    end
  end
end
