# frozen_string_literal: true

module GageScrapper
  # Give it an gage URL and it will parse it to waterflow data
  class RemoteTable
    class HttpStatusError < StandardError; end

    class ConnectionError < StandardError; end
    WaterflowRow = Struct.new(:captured_at, :stage, :discharge, :_captured_at, keyword_init: true)

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def success?
      response.status.success?
    end

    def failure?
      !response.status.success?
    end

    def rows(number_line = nil)
      raise HttpStatusError, "invalid http status #{response.code}" if failure?
      return all_rows if number_line.nil?
      return if number_line.size < number_line

      waterflow(row_lines[number_line])
    end

    def error
      return if success?

      response.body.to_s
    end

    private

    def by_lines
      @by_lines ||= response.to_s.split(/\r\n/)
    end

    def row_lines
      @row_lines ||= by_lines[4..]
    end

    def response
      @response ||= HTTP.get(url)
    rescue HTTP::Error => e
      raise ConnectionError, e.message
    end

    def waterflow(line)
      row_line = line.split

      WaterflowRow.new(
        captured_at: format_date(
          date: row_line[0],
          time: row_line[1]
        ),
        stage: row_line[2],
        discharge: row_line[3]
      )
    end

    def all_rows
      row_lines.map do |line|
        waterflow(line)
      end
    end

    def format_date(date:, time:)
      "#{date.strip} #{time.strip}"
    end
  end
end
