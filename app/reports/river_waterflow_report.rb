# frozen_string_literal: true

# River wateflow reports for given river and dates generate output to specified format
class RiverWaterflowReport
  attr_reader :river, :start_date, :end_date
  def initialize(river:, start_date:, end_date:)
    @river = river
    @start_date = start_date
    @end_date = end_date
  end

  def to_csv
    file_path = "#{Rails.root}/tmp/river_#{river.id}_#{SecureRandom.uuid}.csv"

    CSV.open(file_path, 'w+') do |csv|
      csv << headers
      river_waterflows.find_each(batch_size: 100) do |wf|
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
    [waterflow.captured_at.to_s(:report), waterflow.stage, waterflow.discharge]
  end

  def river_waterflows
    river.waterflows_captured_at_between(start_date, end_date)
  end
end
