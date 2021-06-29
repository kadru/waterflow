# frozen_string_literal: true

# Mailer that sends reports
class ReportMailer < ApplicationMailer
  def gage_report(gage_id:, recipient:, file_path:)
    @gage = Gage.find gage_id
    file = File.read(file_path)
    attachments["waterflow_#{@gage.name}.csv"] = file

    mail(
      to: recipient,
      subject: I18n.t(
        'mailer.report_mailer.gage_report.subject',
        gage_name: @gage.name
      )
    )
  end
end
