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
  end
end
