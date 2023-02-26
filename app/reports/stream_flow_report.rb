# frozen_string_literal: true

# Generate stream flow report
class StreamFlowReport
  attr_reader :gage_id, :start_date, :end_date

  def initialize(gage_id:, start_date:, end_date:)
    @gage_id = gage_id
    @start_date = start_date
    @end_date = end_date
  end

  def to_csv
    file_path = Rails.root.join "/tmp/gage_#{gage_id}_#{SecureRandom.uuid}.csv"

    CSV.open(file_path, 'w+') do |csv|
      csv << headers
      gage_waterflows.stream.each do |wf|
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
    [waterflow[:captured_at].strftime('%Y/%m/%d %H:%M'),
     waterflow[:stage],
     waterflow[:discharge]]
  end

  def gage_waterflows
    DB[:waterflows]
      .select(:captured_at, :stage, :discharge)
      .where(gage_id:)
      .where(captured_at: start_date..end_date.to_date.end_of_day)
      .order(:captured_at)
  end
end
