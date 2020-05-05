# frozen_string_literal: true

# River view object
class RiverView < SimpleDelegator
  def offset
    sec = super

    format('%+03d:%02d', sec / 3600, sec / 60 % 60)
  end
end
