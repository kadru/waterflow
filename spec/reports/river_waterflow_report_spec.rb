# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe RiverWaterflowReport do
  describe '.to_csv' do
    it 'returns a csv file' do
      river = create(:river)
      create(:waterflow, captured_at: Time.zone.local(2020, 1, 1, 1, 0), river: river)
      create(:waterflow, captured_at: Time.zone.local(2020, 1, 1, 2, 0), river: river)

      report = described_class.new river: river, start_date: '2020-01-1', end_date: '2020-06-2'
      file = report.to_csv

      expect(File.extname(file.path)).to eq '.csv'
      expect(file.path).to match(/river_#{river.id}/)
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
