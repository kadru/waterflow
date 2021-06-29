# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaterflowApp do
  describe '.send_gage_report' do
    it 'generates a report and send it via email' do
      gage = create(:gage_with_waterflows)
      user = create(:user)
      message_delivery = instance_double(ActionMailer::MessageDelivery)

      allow(ReportMailer).to receive(:gage_report) {
        message_delivery
      }
      allow(message_delivery).to receive(:deliver_later)

      expect(ReportMailer).to receive(:gage_report).with(
        gage_id: gage.id,
        recipient: user.email,
        file_path: match(%r{tmp/})
      )

      expect(message_delivery).to receive(:deliver_later)

      described_class.send_gage_report(
        gage_id: gage.id,
        email: user.email,
        start_date: '2020-01-01',
        end_date: '2020-01-02'
      )
    end
  end
end
