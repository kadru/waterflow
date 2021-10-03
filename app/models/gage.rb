# frozen_string_literal: true

# Stores gage data
class Gage < ApplicationRecord
  include PgSearch::Model

  has_many :waterflows, -> { order(:captured_at) }, dependent: :destroy
  belongs_to :last_waterflow, foreign_key: :last_waterflow_id, optional: true, class_name: 'Waterflow'

  scope :all_with_waterflows, -> { includes(:last_waterflow).order(:id) }

  pg_search_scope :search, against: %i[name ibcw_id]

  # @param search [String]
  # @return [ActiveRecord::Relation]
  def self.search_or_all_with_waterflows(search = nil)
    return all_with_waterflows if search.blank?

    search(search).all_with_waterflows
  end

  validates :ibcw_id,
            presence: true,
            uniqueness: true
  validates :name,
            presence: true
  validates :url,
            presence: true,
            uniqueness: true
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
  validates :latitude,
            numericality: true,
            allow_nil: true,
            inclusion: { in: -90..90 }
  validates :longitude,
            numericality: true,
            allow_nil: true,
            inclusion: { in: -180..180 }
  validate :valid_url

  before_validation :set_offset

  attr_accessor :offset_hours, :offset_minutes

  delegate :captured_at_between, to: :waterflows, prefix: true

  def self.for_select
    pluck(:name, :id)
  end

  def as_view
    GageView.new(self)
  end

  def offset_time
    Offset.new(offset)
  end

  def last_waterflow_captured_at
    return if last_waterflow.nil?

    last_waterflow.captured_at
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
