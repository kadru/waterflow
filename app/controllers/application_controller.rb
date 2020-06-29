# frozen_string_literal: true

# Main controller
class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Backend
  helper_method :page_title

  private

  def page_title
    nil
  end
end
