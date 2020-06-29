# frozen_string_literal: true

module RiverScrapper
  # Give it river record will save waterflow data of that river
  class Main
    def self.call(river)
      new(river: river, remote_table: RemoteTable.new(river.url)).call
    end

    delegate :rows, to: :remote_table, private: true
    def initialize(river:, remote_table:)
      @river = river
      @remote_table = remote_table
    end

    def call
      rows.each do |wf|
        waterflow = river.waterflows.create(
          captured_at: parse_date(wf.captured_at),
          stage: wf.stage,
          discharge: wf.discharge
        )
        break if unique_error?(waterflow)
      end
    end

    private

    attr_reader :remote_table, :river

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
        river.offset
      )
    end
  end
end
