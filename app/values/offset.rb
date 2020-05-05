# frozen_string_literal: true

# Class which represents offset with conversions
class Offset
  attr_reader :offset
  def initialize(offset)
    @offset = offset || 0
  end

  def hours
    (offset / 3600).round(1)
  end

  def minutes
    (offset % 3600 / 60).round(1)
  end
end
