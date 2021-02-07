# frozen_string_literal: true

namespace :spider_worker do
  desc 'Sync waterflow data for river Conchos 08373000'
  task crawl_conchos: :environment do
    SpiderWorker.perform('08373000')
  end
end
