# frozen_string_literal: true

# Gage index view
class GageIndexComponent < ApplicationComponent
  def initialize(gages:, pagy:, search: nil)
    @gages = gages
    @pagy = pagy
    @search = search
  end

  attr_reader :gages, :pagy, :search
end
