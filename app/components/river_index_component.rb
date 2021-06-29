# frozen_string_literal: true

# River index view
class RiverIndexComponent < ApplicationComponent
  def initialize(rivers:, pagy:)
    @rivers = rivers
    @pagy = pagy
  end

  attr_reader :rivers, :pagy

  private

  def privado
    'privado'
  end
end
