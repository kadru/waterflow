# frozen_string_literal: true

# This module define application procedures
module WaterflowApp
  def self.send_river_report(river_id:, start_date:, end_date:, email:)
    csv_file = StreamFlowReport.new(
      river_id: river_id,
      start_date: start_date,
      end_date: end_date
    ).to_csv

    ReportMailer.river_report(
      river_id: river_id,
      recipient: email,
      file_path: csv_file.path
    ).deliver_later
  ensure
    csv_file.close
  end
end
