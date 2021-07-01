# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageView do
  xdescribe '#offset' do
    context 'when gage#offset is positive' do
      it 'returns a UTC offset' do
        gage = instance_double(Gage, offset: 12.hours.seconds)
        gage_view = described_class.new(gage)

        expect(gage_view.offset).to eq('+12:00')
      end
    end

    context 'when gage#offset is negative' do
      it 'returns a negative UTC offset' do
        gage = instance_double(Gage, offset: -8.hours.seconds)
        gage_view = described_class.new(gage)

        expect(gage_view.offset).to eq('-08:00')
      end
    end
  end

  describe '#last_waterflow_captured_at' do
    it 'returns captured_at date formated with report' do
      subject = described_class.new(instance_double(Gage, last_waterflow_captured_at: Time.new(2021, 6, 12, 13, 15)))

      expect(subject.last_waterflow_captured_at).to eq('2021/06/12 13:15')
    end

    context 'when last_waterflow_caputured is nil' do
      it 'returns missing waterflow data' do
        subject = described_class.new(instance_double(Gage, last_waterflow_captured_at: nil))

        expect(subject.last_waterflow_captured_at).to eq(translate!('view_object.gage_view.missing_last_captured_at'))
      end
    end
  end
end
