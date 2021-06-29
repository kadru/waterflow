# frozen_string_literal: true

# Gage index view
class GageIndexComponent < ApplicationComponent
  def initialize(gages:, pagy:)
    @gages = gages
    @pagy = pagy
  end

  attr_reader :gages, :pagy

  private

  def privado
    'privado'
  end
end
