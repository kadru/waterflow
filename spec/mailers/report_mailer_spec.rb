# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  before do
    ActionMailer::Base.deliveries.clear
    # BUG
    # ActionMailer::Base.deliveries array doesn't fill when perfom_later method is called on mailers
    # the below code fixes it, see https://github.com/rails/rails/issues/37270
    (ActiveJob::Base.descendants << ActiveJob::Base).each(&:disable_test_adapter)
    # Maybe move this to config.before(:suite)
  end

  before :all do
    ENV['DEFAULT_SENDER_EMAIL'] = 'noreply@waterflowapp.com'
  end

  after :all do
    ENV.delete 'DEFAULT_SENDER_EMAIL'
  end

  describe '.gage_report' do
    let(:mail) do
      gage = create(:gage, name: 'conchos')

      described_class.gage_report(
        gage_id: gage.id,
        recipient: 'example@example.com',
        file_path: Tempfile.new('flujo_agua_medidor_conchos').path
      )
    end

    it 'render the headers' do
      expect(mail.subject).to eq(
        I18n.t(
          'mailer.report_mailer.gage_report.subject',
          gage_name: 'conchos'
        )
      )
      expect(mail.to).to eq(['example@example.com'])
      expect(mail.from).to eq(['noreply@waterflowapp.com'])
    end

    it 'render the body' do
      expect(mail.body.encoded).to match(/Ya esta listo el reporte que solicitaste del medidor/)
    end

    it 'sends an email' do
      expect do
        mail.deliver_later
      end.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)
    end

    it 'attach a report' do
      attachment = mail.attachments[0]

      expect(mail.attachments).not_to be_empty
      expect(attachment.filename).to match('waterflow_conchos')
    end
  end
end
