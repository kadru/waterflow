# frozen_string_literal: true

# Gage wateflow reports for given gage and dates generate output to specified format
class GageWaterflowReport
  attr_reader :gage, :start_date, :end_date

  def initialize(gage:, start_date:, end_date:)
    @gage = gage
    @start_date = start_date
    @end_date = end_date
  end

  def to_csv
    file_path = "#{Rails.root}/tmp/gage_#{gage.id}_#{SecureRandom.uuid}.csv"

    CSV.open(file_path, 'w+') do |csv|
      csv << headers
      gage_waterflows.find_each(batch_size: 100) do |wf|
        csv << rows(wf)
      end
    end
    File.new(file_path)
  end

  private

  def headers
    [
      I18n.t('reports.gage_waterflow.headers.captured_at'),
      I18n.t('reports.gage_waterflow.headers.stage'),
      I18n.t('reports.gage_waterflow.headers.discharge')
    ]
  end

  def rows(waterflow)
    [waterflow.captured_at.to_s(:report), waterflow.stage, waterflow.discharge]
  end

  def gage_waterflows
    gage.waterflows_captured_at_between(start_date, end_date)
  end
end
