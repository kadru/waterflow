# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RiverScrapper::Main do
  before do
    stub_request(
      :get,
      'https://ibwc.gov/river_id.txt'
    ).to_return(
      body: file_fixture(body),
      status: status
    )
  end

  after(:context) do
    WebMock.allow_net_connect!
  end

  describe '.call' do
    let(:body) { 'wad.txt' }
    let(:status) { 200 }

    it 'downloads waterflow data and save it to a river' do
      river = create(:river, url: 'https://ibwc.gov/river_id.txt', offset: -6.hours.seconds)
      described_class.call(river)

      expect(river.waterflows.first).to have_attributes(
        captured_at: Time.new(2020, 1, 31, 23, 0, 0, '-06:00'),
        stage: BigDecimal('0.1234e1'),
        discharge: BigDecimal('0.78e0')
      )

      expect(river.waterflows.last).to have_attributes(
        captured_at: Time.new(2020, 1, 31, 22, 45, 0, '-06:00'),
        stage: BigDecimal('0.1233e1'),
        discharge: BigDecimal('0.77e0')
      )
    end
  end

  describe '#call' do
    let(:river) do
      create(:river, url: 'https://ibwc.gov/river_id.txt', offset: -6.hours.seconds)
    end

    let(:body) { 'wad.txt' }
    let(:status) { 200 }

    subject(:service) do
      described_class.new river: river, remote_table: RiverScrapper::RemoteTable.new(river.url)
    end

    it 'downloads waterflow data and save it to a river' do
      service.call

      expect(river.waterflows.first).to have_attributes(
        captured_at: Time.new(2020, 1, 31, 23, 0, 0, '-06:00'),
        stage: BigDecimal('0.1234e1'),
        discharge: BigDecimal('0.78e0')
      )

      expect(river.waterflows.last).to have_attributes(
        captured_at: Time.new(2020, 1, 31, 22, 45, 0, '-06:00'),
        stage: BigDecimal('0.1233e1'),
        discharge: BigDecimal('0.77e0')
      )
    end

    context 'when a waterflow data have same captured_at date' do
      let(:body) { 'wad_double.txt' }

      it 'stops saving data' do
        service.call

        expect(river.waterflows.first).to have_attributes(
          captured_at: Time.new(2020, 1, 31, 23, 0, 0, '-06:00'),
          stage: BigDecimal('0.1234e1'),
          discharge: BigDecimal('0.78e0')
        )

        expect(Waterflow.where(river_id: river.id).size).to eq 1
      end
    end

    context 'when an http error happens' do
      let(:body) { 'wad.txt' }
      let(:status) { 500 }

      it 'raises an HTTP error' do
        expect { service.call }.to raise_error(RiverScrapper::RemoteTable::HttpStatusError)
      end
    end
  end
end
