# frozen_string_literal: true

# Render a gage form
class GageComponent < ApplicationComponent
  attr_reader :gage

  def initialize(gage:)
    @gage = gage
  end
end
