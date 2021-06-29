# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StreamFlowReport do
  around do |example|
    DB.transaction(rollback: :always, &example)
  end

  describe '.to_csv' do
    it 'returns a csv file' do
      gage_id = DB[:gages].insert(
        name: 'conchos',
        ibcw_id: '5000',
        url: 'http://example.com',
        offset: 0,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      )

      DB[:waterflows].multi_insert(
        [
          {
            id: 1,
            captured_at: Time.zone.local(2020, 1, 2, 23, 55),
            gage_id: gage_id,
            stage: 9.0,
            discharge: 3.0,
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          },
          {
            id: 2,
            captured_at: Time.zone.local(2020, 1, 1, 0, 0),
            gage_id: gage_id,
            stage: 1.0,
            discharge: 2.0,
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          },
          {
            id: 3,
            captured_at: Time.zone.local(2020, 1, 1, 2, 0),
            gage_id: gage_id,
            stage: 1.0,
            discharge: 2.0,
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          },
          {
            id: 4,
            captured_at: Time.zone.local(2020, 1, 3, 0, 0),
            gage_id: gage_id,
            stage: 1.0,
            discharge: 2.0,
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          }
        ]
      )

      report = described_class.new gage_id: gage_id, start_date: '2020-01-1', end_date: '2020-01-2'
      file = report.to_csv

      expect(File.extname(file.path)).to eq '.csv'
      expect(file.path).to match(/gage_#{gage_id}/)
      expect(CSV.read(file.path)).to eq(
        [
          %w[fecha etapa descarga], # headers
          ['2020/01/01 00:00', '1.0', '2.0'], # rows
          ['2020/01/01 02:00', '1.0', '2.0'],
          ['2020/01/02 23:55', '9.0', '3.0']
        ]
      )
    end
  end
end
