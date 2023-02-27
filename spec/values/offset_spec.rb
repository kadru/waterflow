# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offset do
  describe '#hours' do
    it 'returns the hour parth of the offset' do
      subject = described_class.new 5400

      expect(subject.hours).to eq(1)
    end
  end

  describe '#minutes' do
    it 'returns minute part of the offset' do
      subject = described_class.new 5400

      expect(subject.minutes).to eq(30)
    end
  end
end
