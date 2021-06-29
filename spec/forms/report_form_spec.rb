# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportForm, type: :model do
  describe '#start_date' do
    it { is_expected.to validate_presence_of(:start_date) }

    it 'must not to be greater than #end_date' do
      report_form = described_class.new(
        start_date: Date.new(2020, 2, 1),
        end_date: Date.new(2020, 1, 1)
      )

      expect(report_form).to_not be_valid
      expect(report_form.errors.details).to have_key(:start_date)
    end
  end

  describe '#end_date' do
    it { is_expected.to validate_presence_of(:end_date) }

    it 'must not to be smaller than #start_date' do
      report_form = described_class.new(
        start_date: Date.new(2020, 2, 1),
        end_date: Date.new(2020, 1, 1)
      )

      expect(report_form).to_not be_valid
      expect(report_form.errors.details).to have_key(:end_date)
    end
  end

  describe '#gage_id' do
    it { is_expected.to validate_presence_of(:gage_id) }
    it { is_expected.to validate_numericality_of(:gage_id).only_integer }

    let(:gage) { create(:gage) }

    context 'when gage not exists' do
      it 'is not valid' do
        report_form = described_class.new(
          start_date: Date.new(2020, 2, 1),
          end_date: Date.new(2020, 2, 2),
          gage_id: gage.id + 1
        )

        expect(report_form).not_to be_valid
        expect(report_form.errors.details).to have_key(:gage_id)
      end
    end

    context 'when gage exists' do
      it 'it is valid' do
        report_form = described_class.new(
          start_date: Date.new(2020, 2, 1),
          end_date: Date.new(2020, 2, 2),
          gage_id: gage.id
        )

        expect(report_form).to be_valid
        expect(report_form.errors.details).to_not have_key(:gage_id)
      end
    end
  end
end
