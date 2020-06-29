# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpiderWorker do
  describe '.perform' do
    it 'delegate the river scrap work to RiverScrapper' do
      river = create(:river)
      allow(RiverScrapper::Main).to receive(:call)

      described_class.perform_async(river.ibcw_id)

      expect(RiverScrapper::Main).to have_received(:call).with(river)
    end
  end
end
