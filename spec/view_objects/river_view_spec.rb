# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RiverView do
  describe '#offset' do
    context 'when river#offset is positive' do
      it 'returns a UTC offset' do
        river = instance_double(River, offset: 12.hours.seconds)
        river_view = described_class.new(river)

        expect(river_view.offset).to eq('+12:00')
      end
    end

    context 'when river#offset is negative' do
      it 'returns a negative UTC offset' do
        river = instance_double(River, offset: -8.hours.seconds)
        river_view = described_class.new(river)

        expect(river_view.offset).to eq('-08:00')
      end
    end
  end
end
