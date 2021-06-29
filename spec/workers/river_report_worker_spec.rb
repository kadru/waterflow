# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageReportWorker do
  describe '.perform' do
    it 'delegate the generation and send of report to WaterflowApp procedure' do
      allow(WaterflowApp).to receive(:send_gage_report)

      described_class.perform_async(
        1,
        '17/12/2021',
        '20/12/2021',
        'example@example.com'
      )

      expect(WaterflowApp).to have_received(:send_gage_report).with(
        gage_id: 1,
        start_date: '17/12/2021',
        end_date: '20/12/2021',
        email: 'example@example.com'
      )
    end
  end
end
