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

  describe '.all_with_waterflows' do
    it 'returns gages with waterflows included' do
      gages = create_list(:gage_with_waterflows, 2)

      expect(described_class.all_with_waterflows).to eq(gages)
    end
  end

  describe '.search_or_all_with_waterflows' do
    context 'when params search is a name' do
      it 'returns gages names matches' do
        create(:gage, name: 'Conchos')
        create(:gage, name: 'Bravo')
        create(:gage, name: 'rio conchos')

        expect(described_class.search_or_all_with_waterflows('conchos')).to match_array(
          [
            have_attributes(name: 'Conchos'),
            have_attributes(name: 'rio conchos')
          ]
        )
      end

      context 'when there are not matches' do
        it 'returns a empty collection' do
          create(:gage, name: 'Conchos')
          create(:gage, name: 'Bravo')

          expect(described_class.search_or_all_with_waterflows('not matches')).to be_empty
        end
      end
    end

    context 'when param search is a ibcw_id' do
      it 'returns gages ibcw_id matches' do
        create(:gage, ibcw_id: '850', name: 'Conchos')
        create(:gage, ibcw_id: '230', name: 'Bravo')
        create(:gage, ibcw_id: '231', name: 'rio conchos')

        expect(described_class.search_or_all_with_waterflows('850')).to match_array(
          [
            have_attributes(ibcw_id: '850', name: 'Conchos')
          ]
        )
      end
    end

    context 'when search param is blank' do
      it 'returns all gages' do
        create(:gage, name: 'Conchos')
        create(:gage, name: 'Bravo')

        expect(described_class.search_or_all_with_waterflows('')).to match_array(
          [
            have_attributes(name: 'Conchos'),
            have_attributes(name: 'Bravo')
          ]
        )
      end
    end

    context 'when search param is not given' do
      it 'returns all gages' do
        create(:gage, name: 'Conchos')
        create(:gage, name: 'Bravo')

        expect(described_class.search_or_all_with_waterflows).to match_array(
          [
            have_attributes(name: 'Conchos'),
            have_attributes(name: 'Bravo')
          ]
        )
      end
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
    it { is_expected.to validate_uniqueness_of(:url) }

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

  describe '#latitude' do
    it { is_expected.to validate_numericality_of(:latitude).allow_nil }
    it { is_expected.to validate_inclusion_of(:latitude).in_range(-90..90) }
  end

  describe '#longitude' do
    it { is_expected.to validate_numericality_of(:longitude).allow_nil }
    it { is_expected.to validate_inclusion_of(:longitude).in_range(-180..180) }
  end

  describe '#waterflows_captured_at_between' do
    it 'returns waterflows between given dates' do
      gage = create(:gage)
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 14, 1),
        gage:
      )
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 10, 1),
        gage:
      )
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 15),
        gage:
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
    subject(:gage) { described_class.new }

    it 'returns a view object' do
      expect(gage.as_view).to be_instance_of(GageView)
    end
  end

  describe '#offset_time' do
    subject(:gage) { described_class.new }

    it 'returns an offset object' do
      expect(gage.offset_time).to be_instance_of(Offset)
    end
  end

  describe '#last_waterflow_captured_at' do
    context 'when has associated waterflows' do
      subject(:gage) do
        gage = create(:gage)
        create(:waterflow, gage:, captured_at: Time.zone.local(2021, 6, 12, 13, 0))
        create(:waterflow, gage:, captured_at: Time.zone.local(2021, 6, 12, 13, 15))
        gage.reload
      end

      it 'returns the last captured waterflow date' do
        expect(gage.last_waterflow_captured_at).to eq(Time.zone.local(2021, 6, 12, 13, 15))
      end
    end

    context 'when has not associated waterflows' do
      subject(:gage) { described_class.new }

      it 'returns nil' do
        expect(gage.last_waterflow_captured_at).to eq(nil)
      end
    end
  end

  describe '#last_waterflow' do
    it 'returns the last waterflow' do
      subject = create(:gage)
      waterflow = subject.waterflows.create(captured_at: Time.zone.now, stage: 1, discharge: 1)
      subject.reload

      expect(subject.last_waterflow).to eq(waterflow)
    end
  end
end
