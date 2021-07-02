# frozen_string_literal: true

module GageScrapper
  # Wraps row data in accessors and parses it at initialization
  class WaterflowRow
    attr_reader :stage, :discharge, :precipitation

    def initialize(captured_at:, stage:, discharge:, precipitation:)
      @captured_at = captured_at
      @stage = to_big_decimal(stage)
      @discharge = to_big_decimal(discharge)
      @precipitation = to_big_decimal(precipitation)
    end

    def captured_at(timezone = nil)
      parse_date(@captured_at, timezone)
    end

    private

    def to_big_decimal(value)
      return if value.nil?
      return if value.downcase == 'nan'

      BigDecimal(value)
    end

    def parse_date(value, timezone)
      date_integers = value.scan(/\d+/)

      Time.new(
        date_integers[2],
        date_integers[0],
        date_integers[1],
        date_integers[3],
        date_integers[4],
        0,
        timezone
      )
    end
  end
end
