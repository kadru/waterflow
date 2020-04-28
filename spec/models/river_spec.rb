# frozen_string_literal: true

require 'rails_helper'

RSpec.describe River, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:waterflows) }
  end

  describe '.for_select' do
    it 'returns an array for select tag helper' do
      create_list(:river, 2)

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
        river = build(:river, url: 'http://www.example.com')

        expect(river).to be_valid
      end
    end

    context 'when invalid URL is given' do
      it 'must be invalid' do
        river = build(:river, url: 'invalid url')
        river_without_host = build(:river, url: '/get')

        expect(river).not_to be_valid
        expect(river_without_host).not_to be_valid
      end
    end
  end

  describe '#offset' do
    it { is_expected.to validate_presence_of(:offset) }
    it { is_expected.to validate_numericality_of(:offset).only_integer }
    it { is_expected.to validate_inclusion_of(:offset).in_range(-43_200..50_400) }
  end
end
