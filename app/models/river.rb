# frozen_string_literal: true

# Stores river data
class River < ApplicationRecord
  has_many :waterflows

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
  validate :valid_url

  def self.for_select
    pluck(:name, :id)
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
end
