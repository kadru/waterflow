# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpiderWorker do
  describe '.perform' do
    it 'delegate the gage scrap work to GageScrapper' do
      gage = create(:gage)
      allow(GageScrapper::Main).to receive(:call)

      described_class.perform_async(gage.ibcw_id)

      expect(GageScrapper::Main).to have_received(:call).with(gage)
    end
  end
end
