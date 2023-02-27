# frozen_string_literal: true

require 'rails_helper'

# Tests fails with Time.zone.local, so disable this cop
# rubocop:disable Rails/TimeZone

RSpec.describe GageScrapper::WaterflowRow do
  subject(:waterflow_row) do
    described_class.new captured_at: '07/01/2021 11:15', stage: '2.077', discharge: '1.34', precipitation: '77.60'
  end

  describe '#captured_at' do
    it 'returns captured_at date' do
      expect(waterflow_row.captured_at).to eq(Time.new(2021, 7, 1, 11, 15, 0))
    end

    context 'when time zone is given' do
      it 'returns the captured_at date with timezone' do
        tz = 43_200

        expect(waterflow_row.captured_at(tz)).to eq(Time.new(2021, 7, 1, 11, 15, 0, '+12:00'))
      end
    end
  end

  describe '#stage' do
    it 'returns stage value' do
      expect(waterflow_row.stage).to eq(BigDecimal('2.077'))
    end

    context 'when value is nan' do
      subject(:waterflow_row) do
        described_class.new captured_at: '07/01/2021 11:15', stage: 'nan', discharge: '1.34', precipitation: '77.60'
      end

      it 'returns nil' do
        expect(waterflow_row.stage).to eq(nil)
      end
    end
  end

  describe '#discharge' do
    it 'returns discharge value' do
      expect(waterflow_row.discharge).to eq(BigDecimal('1.34'))
    end

    context 'when value is nan' do
      subject(:waterflow_row) do
        described_class.new captured_at: '07/01/2021 11:15', stage: '2.077', discharge: 'nan', precipitation: '77.60'
      end

      it 'returns nil' do
        expect(waterflow_row.discharge).to eq(nil)
      end
    end
  end

  describe '#precipitation' do
    it 'returns precipitation value' do
      expect(waterflow_row.precipitation).to eq(BigDecimal('77.60'))
    end

    context 'when value is nan' do
      subject(:waterflow_row) do
        described_class.new captured_at: '07/01/2021 11:15', stage: '2.077', discharge: '1.34', precipitation: 'nan'
      end

      it 'returns nil' do
        expect(waterflow_row.precipitation).to eq(nil)
      end
    end
  end
end
# rubocop:enable Rails/TimeZone
