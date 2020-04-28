# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonkeyPatches::ActiveSupport::TimeZone do
  describe '#to_s' do
    it 'translate timezone' do
      subject = ActiveSupport::TimeZone.new('International Date Line West')

      expect(subject.to_s).to eq('(GMT-12:00) Línea de fecha internacional del oeste')
    end
  end
end
