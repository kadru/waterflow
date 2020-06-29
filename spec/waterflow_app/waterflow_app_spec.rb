# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaterflowApp do
  describe '.send_river_report' do
    it 'generates a report and send it via email' do
      river = create(:river_with_waterflows)
      user = create(:user)
      message_delivery = instance_double(ActionMailer::MessageDelivery)

      allow(ReportMailer).to receive(:river_report) {
        message_delivery
      }
      allow(message_delivery).to receive(:deliver_later)

      expect(ReportMailer).to receive(:river_report).with(
        river_id: river.id,
        recipient: user.email,
        file_path: match(%r{tmp/})
      )

      expect(message_delivery).to receive(:deliver_later)

      described_class.send_river_report(
        river_id: river.id,
        email: user.email,
        start_date: '2020-01-01',
        end_date: '2020-01-02'
      )
    end
  end
end
