# frozen_string_literal: true

# Spider worker
class SpiderWorker
  include Sidekiq::Worker

  def self.perform(ibcw_id)
    new.perform(ibcw_id)
  end

  def perform(ibcw_id)
    gage = Gage.find_by! ibcw_id: ibcw_id
    GageScrapper::Main.call(gage)
  rescue StandardError => e
    Bugsnag.notify(e) do |report|
      report.add_tab(:gage, { gage_ibcw_id: ibcw_id, gage_url: gage.url })
    end
    e.instance_eval { def skip_bugsnag = true }

    raise e
  end
end
