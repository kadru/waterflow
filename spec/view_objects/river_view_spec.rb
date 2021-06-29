# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageView do
  describe '#offset' do
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
end
