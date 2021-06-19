# frozen_string_literal: true

# Generate stream flow report
class StreamFlowReport
  attr_reader :river_id, :start_date, :end_date

  def initialize(river_id:, start_date:, end_date:)
    @river_id = river_id
    @start_date = start_date
    @end_date = end_date
  end

  def to_csv
    file_path = "#{Rails.root}/tmp/river_#{river_id}_#{SecureRandom.uuid}.csv"

    CSV.open(file_path, 'w+') do |csv|
      csv << headers
      river_waterflows.stream.each do |wf|
        csv << rows(wf)
      end
    end
    File.new(file_path)
  end

  private

  def headers
    [
      I18n.t('reports.river_waterflow.headers.captured_at'),
      I18n.t('reports.river_waterflow.headers.stage'),
      I18n.t('reports.river_waterflow.headers.discharge')
    ]
  end

  def rows(waterflow)
    [waterflow[:captured_at].strftime('%Y/%m/%d %H:%M'),
     waterflow[:stage],
     waterflow[:discharge]]
  end

  def river_waterflows
    DB[:waterflows]
      .select(:captured_at, :stage, :discharge)
      .where(river_id: river_id)
      .where(captured_at: start_date..end_date.to_date.end_of_day)
      .order(:captured_at)
  end
end
