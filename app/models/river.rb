# frozen_string_literal: true

# Stores river data
class River < ApplicationRecord
  has_many :waterflows, dependent: :destroy

  validates :ibcw_id,
            presence: true,
            uniqueness: true
  validates :name,
            presence: true
  validates :url,
            presence: true
  validates :offset,
            presence: true,
            inclusion: { in: -43_200..50_400 },
            numericality: { only_integer: true }
  validates :offset_hours,
            allow_nil: true,
            numericality: { only_integer: true }
  validates :offset_minutes,
            allow_nil: true,
            numericality: { only_integer: true }
  validate :valid_url

  before_validation :set_offset

  attr_accessor :offset_hours, :offset_minutes

  def self.for_select
    pluck(:name, :id)
  end

  def as_view
    RiverView.new(self)
  end

  def offset_time
    Offset.new(offset)
  end

  private

  def valid_url
    return if url.nil?

    uri = URI.parse(url)
    return unless uri.host.nil?

    add_url_error
  rescue URI::InvalidURIError
    add_url_error
  end

  def add_url_error
    errors.add(
      :url,
      :invalid_url
    )
  end

  def set_offset
    return if offset_hours.nil? || offset_minutes.nil?

    self.offset = (offset_hours.to_i * 3600 + offset_minutes.to_i * 60)
  end
end
