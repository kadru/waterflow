# frozen_string_literal: true

# Stores csp violations
class CspViolationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    CspViolation.create!(data: params.require('csp-report').permit!)
  end
end
