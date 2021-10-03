# frozen_string_literal: true

# renders a gage map
class GageMapComponent < ApplicationComponent
  include ViewComponent::Translatable
  attr_reader :gage

  def initialize(gage:)
    @gage = gage
  end
end
