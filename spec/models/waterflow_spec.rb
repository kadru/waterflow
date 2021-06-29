# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Waterflow, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:gage) }
    it { is_expected.to validate_presence_of(:gage) }
  end

  describe '.captured_at_between' do
    it 'returns waterflow between given dates' do
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 14, 1)
      )
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 10, 1)
      )
      create(
        :waterflow,
        captured_at: Time.zone.local(2020, 6, 15)
      )

      waterflows = described_class.captured_at_between('2020-06-11', '2020-06-14')

      expect(waterflows).to all(
        have_attributes(captured_at: be < Time.zone.local(2020, 6, 15))
      )
      expect(waterflows).to all(
        have_attributes(captured_at: be > Time.zone.local(2020, 6, 10))
      )
      expect(waterflows.size).to eq 1
    end
  end

  describe '#stage' do
    it { is_expected.to validate_numericality_of(:stage) }
  end

  describe '#discharge' do
    it { is_expected.to validate_numericality_of(:discharge) }
  end

  describe '#unique_error?' do
    let(:gage) { create(:gage) }
    let(:date) { Time.new(2020, 1, 1, 23, 0) }
    before do
      create(:waterflow, captured_at: date, gage: gage)
    end

    context 'when a unique validation error happens with given attribute' do
      it 'returns true' do
        subject = build(:waterflow, captured_at: date, gage: gage)
        subject.valid?

        expect(subject.unique_error?(:captured_at)).to eq(true)
      end
    end

    context 'when none validation error happens with given attribute' do
      it 'returns false' do
        subject = build(:waterflow, captured_at: Time.zone.local(2020, 1, 1, 23, 15), gage: gage)
        subject.valid?

        expect(subject.unique_error?(:captured_at)).to eq(false)
      end
    end

    context 'when the given attribute doesnt exist in the model' do
      it 'returns false' do
        subject = build(:waterflow, gage: gage)
        subject.valid?

        expect(subject.unique_error?(:no_existent_attr)).to eq(false)
      end
    end
  end

  describe '#captured_at' do
    context 'validations' do
      subject { described_class.new gage: create(:gage) }

      it { is_expected.to validate_presence_of(:captured_at) }
      it { is_expected.to validate_uniqueness_of(:captured_at).scoped_to(:gage_id) }
    end
  end

  describe '#local_captured_at' do
    context 'when gage offset is set' do
      it 'returns captured_at date with gage offset' do
        gage_6_offset = create(:gage, offset: -8.hours.seconds)
        waterflow = create(
          :waterflow,
          gage: gage_6_offset,
          captured_at: Time.new(2020, 3, 8, 2, 45, 0, '-08:00')
        )

        expect(waterflow.local_captured_at).to eq(Time.new(2020, 3, 8, 2, 45, 0, '-08:00'))
      end
    end

    context 'when has no gage' do
      it 'raises an error' do
        waterflow = Waterflow.create captured_at: Time.new(2020, 3, 8, 2, 45, 0)
        expect do
          waterflow.local_captured_at
        end.to raise_error(Waterflow::InvalidGageError)
      end
    end

    context 'when gage captured_at is nil' do
      it 'returns nil' do
        waterflow = Waterflow.new captured_at: nil

        expect(waterflow.local_captured_at).to be_nil
      end
    end
  end
end
