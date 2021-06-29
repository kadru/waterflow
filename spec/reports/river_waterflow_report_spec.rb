# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe GageWaterflowReport do
  describe '.to_csv' do
    it 'returns a csv file' do
      gage = create(:gage)
      create(:waterflow, captured_at: Time.zone.local(2020, 1, 1, 1, 0), gage: gage)
      create(:waterflow, captured_at: Time.zone.local(2020, 1, 1, 2, 0), gage: gage)

      report = described_class.new gage: gage, start_date: '2020-01-1', end_date: '2020-06-2'
      file = report.to_csv

      expect(File.extname(file.path)).to eq '.csv'
      expect(file.path).to match(/gage_#{gage.id}/)
      expect(CSV.read(file.path)).to eq(
        [
          %w[fecha etapa descarga], # headers
          ['2020/01/01 01:00', '1.0', '2.0'], # rows
          ['2020/01/01 02:00', '1.0', '2.0']
        ]
      )
    end
  end
end
