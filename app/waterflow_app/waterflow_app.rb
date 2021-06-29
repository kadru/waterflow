# frozen_string_literal: true

# This module define application procedures
module WaterflowApp
  def self.send_gage_report(gage_id:, start_date:, end_date:, email:)
    csv_file = StreamFlowReport.new(
      gage_id: gage_id,
      start_date: start_date,
      end_date: end_date
    ).to_csv

    ReportMailer.gage_report(
      gage_id: gage_id,
      recipient: email,
      file_path: csv_file.path
    ).deliver_later
  ensure
    csv_file.close
  end
end
