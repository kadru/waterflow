# frozen_string_literal: true

# This module define application procedures
module WaterflowApp
  # @param river_id [Integer], start_date [String], end_date [String], email [String]
  # @return void
  def self.send_river_report(river_id:, start_date:, end_date:, email:)
    river = River.find river_id

    csv_file = RiverWaterflowReport.new(
      river: river,
      start_date: start_date,
      end_date: end_date
    ).to_csv

    ReportMailer.river_report(
      river_id: river.id,
      recipient: email,
      file_path: csv_file.path
    ).deliver_later
  ensure
    csv_file.close
  end
end
