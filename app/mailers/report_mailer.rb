# frozen_string_literal: true

# Mailer that sends reports
class ReportMailer < ApplicationMailer
  def river_report(river_id:, recipient:, file_path:)
    @river = River.find river_id
    file = File.read(file_path)
    attachments["waterflow_#{@river.name}.csv"] = file

    mail(
      to: recipient,
      subject: I18n.t(
        'mailer.report_mailer.river_report.subject',
        river_name: @river.name
      )
    )
  end
end
