# frozen_string_literal: true

namespace :spider_worker do
  desc 'Sync waterflow data for gauge Conchos 08373000'
  task crawl_conchos: :environment do
    SpiderWorker.perform('08373000')
  end

  desc 'Sync waterflow data for gauges stored in db'
  task crawl_all: :environment do
    Gage.find_each(batch_size: 10) do |gauge|
      SpiderWorker.perform_async(gauge.ibcw_id)
    end
  end
end
