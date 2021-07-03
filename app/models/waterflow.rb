# frozen_string_literal: true

# Stores waterflow data of gages
class Waterflow < ApplicationRecord
  InvalidGageError = Class.new(StandardError)
  belongs_to :gage

  validates :captured_at,
            uniqueness: { scope: :gage_id },
            presence: true
  validates :gage,
            presence: true
  validates :discharge,
            numericality: true,
            allow_nil: true
  validates :stage,
            numericality: true,
            allow_nil: true
  validates :precipitation,
            numericality: true,
            allow_nil: true

  scope :captured_at_between, lambda { |start_date, end_date|
    where(
      'captured_at BETWEEN ? AND ?',
      start_date.to_date.at_beginning_of_day,
      end_date.to_date.end_of_day
    ).order(:captured_at)
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
    raise InvalidGageError, 'must belongs to a valid gage, gage is nil' if gage.nil?

    gage.offset
  end
end
