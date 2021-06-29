# frozen_string_literal: true

module GageScrapper
  # Give it gage record will save waterflow data of that gage
  class Main
    def self.call(gage)
      new(gage: gage, remote_table: RemoteTable.new(gage.url)).call
    end

    delegate :rows, to: :remote_table, private: true
    def initialize(gage:, remote_table:)
      @gage = gage
      @remote_table = remote_table
    end

    def call
      rows.each do |wf|
        waterflow = gage.waterflows.create(
          captured_at: parse_date(wf.captured_at),
          stage: wf.stage,
          discharge: wf.discharge
        )
        break if unique_error?(waterflow)
      end
    end

    private

    attr_reader :remote_table, :gage

    def unique_error?(waterflow)
      waterflow.invalid? && waterflow.unique_error?(:captured_at)
    end

    def parse_date(date)
      date_integers = date.scan(/\d+/)

      Time.new(
        date_integers[2],
        date_integers[0],
        date_integers[1],
        date_integers[3],
        date_integers[4],
        0,
        gage.offset
      )
    end
  end
end
