# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gage, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:waterflows).dependent(:destroy) }
  end

  describe '.for_select' do
    it 'returns an array for select tag helper' do
      create_list(:gage, 2)

      expect(described_class.for_select).to match_array(
        [
          ['conchos', be_a(Integer)],
          ['conchos', be_a(Integer)]
        ]
      )
    end
  end

  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#ibcw_id' do
    it { is_expected.to validate_presence_of(:ibcw_id) }
    it { is_expected.to validate_uniqueness_of(:ibcw_id) }
  end

  describe '#url' do
    it { is_expected.to validate_presence_of(:url) }

    context 'when valid URL is given' do
      it 'must be valid' do
        gage = build(:gage, url: 'http://www.example.com')

        expect(gage).to be_valid
      end
    end

    context 'when invalid URL is given' do
      it 'must be invalid' do
        gage = build(:gage, url: 'invalid url')
        gage_without_host = build(:gage, url: '/get')

        expect(gage).not_to be_valid
        expect(gage_without_host).not_to be_valid
      end
    end
  end

  describe '#offset' do
    it { is_expected.to validate_presence_of(:offset) }
    it { is_expected.to validate_numericality_of(:offset).only_integer }
    it { is_expected.to validate_inclusion_of(:offset).in_range(-43_200..50_400) }

    context 'when #offset_hours and #offset_minutes have value' do
      it 'they set value of #offset' do
        subject = described_class.new offset_hours: 1, offset_minutes: 30
        subject.valid?

        expect(subject.offset).to eq(5400)
      end
    end
  end

  describe '#offset_hours' do
    it { is_expected.to validate_numericality_of(:offset_hours).only_integer }
  end

  describe '#offset_minutes' do
    it { is_expected.to validate_numericality_of(:offset_minutes).only_integer }
  end

  describe '#waterflows_captured_at_between' do
    it 'returns waterflows between given dates' do
      gage = create(:gage)
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 14, 1),
        gage: gage
      )
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 10, 1),
        gage: gage
      )
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 15),
        gage: gage
      )

      waterflows = gage.waterflows_captured_at_between('2020-06-11', '2020-06-14')

      expect(waterflows).to all(
        have_attributes(captured_at: be < Time.zone.local(2020, 6, 15))
      )
      expect(waterflows).to all(
        have_attributes(captured_at: be > Time.zone.local(2020, 6, 10))
      )
      expect(waterflows.size).to eq 1
    end
  end

  describe '#as_view' do
    it 'returns a view object' do
      expect(subject.as_view).to be_instance_of(GageView)
    end
  end

  describe '#offset_time' do
    it 'returns an offset object' do
      expect(subject.offset_time).to be_instance_of(Offset)
    end
  end
end
