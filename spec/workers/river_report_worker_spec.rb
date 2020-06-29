# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RiverReportWorker do
  describe '.perform' do
    it 'delegate the generation and send of report to WaterflowApp procedure' do
      allow(WaterflowApp).to receive(:send_river_report)

      described_class.perform_async(
        1,
        '17/12/2021',
        '20/12/2021',
        'example@example.com'
      )

      expect(WaterflowApp).to have_received(:send_river_report).with(
        river_id: 1,
        start_date: '17/12/2021',
        end_date: '20/12/2021',
        email: 'example@example.com'
      )
    end
  end
end
