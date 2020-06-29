# frozen_string_literal: true

# Spider worker
class SpiderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :spider_queue

  def perform(ibcw_id)
    river = River.find_by! ibcw_id: ibcw_id
    RiverScrapper::Main.call(river)
  end
end
