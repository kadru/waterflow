# frozen_string_literal: true

# Calls gage report service
class GageReportWorker
  include Sidekiq::Worker

  def perform(gage_id, start_date, end_date, email)
    WaterflowApp.send_gage_report(
      gage_id: gage_id,
      start_date: start_date,
      end_date: end_date,
      email: email
    )
  end
end
