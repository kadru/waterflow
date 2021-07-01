# frozen_string_literal: true

require 'rails_helper'
require 'support/system/clearance_helpers'

RSpec.feature 'User signs out' do
  scenario 'signs out', type: :system, js: true do
    sign_in
    sign_out

    expect_user_to_be_signed_out
  end

  # Cannot have set two drivers for capybara using driven_by until this PR is merged
  # https://github.com/rails/rails/pull/42511
  xcontext 'when is in mobile size', type: :system, mobile: true do
    scenario 'signs out' do
      sign_in
      find('#materialize-select').click
      sign_out

      expect_user_to_be_signed_out
    end
  end
end
