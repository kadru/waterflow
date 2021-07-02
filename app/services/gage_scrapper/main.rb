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
          captured_at: wf.captured_at(gage.offset),
          stage: wf.stage,
          discharge: wf.discharge,
          precipitation: wf.precipitation
        )
        break if unique_error?(waterflow)
      end
    end

    private

    attr_reader :remote_table, :gage

    def unique_error?(waterflow)
      waterflow.invalid? && waterflow.unique_error?(:captured_at)
    end
  end
end
