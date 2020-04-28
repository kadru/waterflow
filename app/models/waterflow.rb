# frozen_string_literal: true

# Stores waterflow data of rivers
class Waterflow < ApplicationRecord
  class InvalidRiverError < StandardError; end
  belongs_to :river

  validates :captured_at,
            uniqueness: { scope: :river_id },
            presence: true
  validates :river,
            presence: true
  validates :discharge,
            numericality: true
  validates :stage,
            numericality: true

  def unique_error?(attribute)
    errors.added?(attribute, 'ya está en uso') # must be :taken but added? method is bugged
  end

  def local_captured_at
    raw_captured_at = captured_at
    return if raw_captured_at.nil?

    raw_captured_at.getlocal(offset)
  end

  private

  def offset
    raise InvalidRiverError, 'must belongs to a valid river, river is nil' if river.nil?

    river.offset
  end
end
