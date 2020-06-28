# frozen_string_literal: true

# Stores waterflow data of rivers
class Waterflow < ApplicationRecord
  InvalidRiverError = Class.new(StandardError)
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

  scope :captured_at_between, lambda { |start_date, end_date|
    where(
      'captured_at BETWEEN ? AND ?',
      start_date.to_date.at_beginning_of_day,
      end_date.to_date.end_of_day
    )
  }

  def unique_error?(attribute)
    errors.of_kind?(attribute, :taken)
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
