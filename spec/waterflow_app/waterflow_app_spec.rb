# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaterflowApp do
  describe '.send_gage_report' do
    around do |ex|
      queue_adapter = ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter = :test

      ex.run

      ActiveJob::Base.queue_adapter = queue_adapter
    end

    it 'generates a report and send it via email' do
      gage = create(:gage_with_waterflows)
      user = create(:user)

      expect do
        described_class.send_gage_report(
          gage_id: gage.id,
          email: user.email,
          start_date: '2020-01-01',
          end_date: '2020-01-02'
        )
      end.to have_enqueued_mail(ReportMailer, :gage_report).with(
        gage_id: gage.id,
        recipient: user.email,
        file_path: /.csv/
      )
    end
  end
end
