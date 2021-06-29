# frozen_string_literal: true

# Gage view object
class GageView < SimpleDelegator
  def offset
    sec = super

    format('%+03d:%02d', sec / 3600, sec / 60 % 60)
  end
end
