# frozen_string_literal: true

# Calls river report service
class RiverReportWorker
  include Sidekiq::Worker

  def perform(river_id, start_date, end_date, email)
    WaterflowApp.send_river_report(
      river_id: river_id,
      start_date: start_date,
      end_date: end_date,
      email: email
    )
  end
end
