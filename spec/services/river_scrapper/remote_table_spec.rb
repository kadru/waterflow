# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageScrapper::RemoteTable do
  before do
    stub_request(
      :get,
      'https://ibwc.gov/gage_id.txt'
    ).to_return(
      body: file_fixture(body),
      status: status
    )
  end

  after(:context) do
    WebMock.allow_net_connect!
  end

  let(:url) { 'https://ibwc.gov/gage_id.txt' }

  describe '#success?' do
    context 'when request was succesful' do
      let(:status) { 200 }
      let(:body) { 'wad.txt' }

      it 'returns true' do
        table = described_class.new url

        expect(table).to be_success
      end
    end

    context 'when http error happpens' do
      let(:status) { 500 }
      let(:body) { 'wad.txt' }

      it 'returns false' do
        table = described_class.new url

        expect(table).not_to be_success
      end
    end
  end

  describe '#failure?' do
    context 'when request was succesful' do
      let(:status) { 200 }
      let(:body) { 'wad.txt' }

      it 'returns false' do
        table = described_class.new url

        expect(table).not_to be_failure
      end
    end

    context 'when http error happpens' do
      let(:status) { 500 }
      let(:body) { 'wad.txt' }

      it 'returns true' do
        table = described_class.new url

        expect(table).to be_failure
      end
    end
  end

  describe '#rows' do
    let(:status) { 200 }
    let(:body) { 'wad.txt' }

    context 'when give line number' do
      it 'returns waterflow data of that line' do
        table = described_class.new url

        expect(table.rows(1)).to have_attributes(
          captured_at: Time.new(2020, 1, 31, 22, 45),
          stage: BigDecimal('1.233'),
          discharge: BigDecimal('0.77'),
          precipitation: nil
        )
      end
    end

    context 'when give line number out of index' do
      it 'returns nil' do
        table = described_class.new url

        expect(table.rows(99)).to be_nil
      end
    end

    context 'when line number is no given' do
      it 'returns all rows' do
        table = described_class.new url

        expect(table.rows.size).to eq(2)
        expect(table.rows).to match_array(
          [
            have_attributes(
              captured_at: Time.new(2020, 1, 31, 23, 0),
              stage: BigDecimal('1.234'),
              discharge: BigDecimal('0.78'),
              precipitation: nil
            ),
            have_attributes(
              captured_at: Time.new(2020, 1, 31, 22, 45),
              stage: BigDecimal('1.233'),
              discharge: BigDecimal('0.77'),
              precipitation: nil
            )
          ]
        )
      end
    end

    context 'when waterflow table has precipitation column' do
      let(:status) { 200 }
      let(:body) { 'wad_with_precipitation.txt' }

      it 'all rows have precipitation attribute' do
        table = described_class.new url

        expect(table.rows).to match_array(
          [
            have_attributes(
              captured_at: Time.new(2021, 7, 1, 11, 15),
              stage: BigDecimal('2.077'),
              discharge: BigDecimal('1.34'),
              precipitation: BigDecimal('77.60')
            ),
            have_attributes(
              captured_at: Time.new(2021, 7, 1, 11, 0),
              stage: BigDecimal('2.077'),
              discharge: BigDecimal('1.34'),
              precipitation: BigDecimal('77.60')
            ),
            have_attributes(
              captured_at: Time.new(2021, 7, 1, 10, 45),
              stage: nil,
              discharge: nil,
              precipitation: nil
            )
          ]
        )
      end
    end

    context 'when a redirect occurrs' do
      let(:url) { 'http://ibwc.gov/gage_id.txt' }

      before do
        redirection = 'https://ibwc.gov/gage_id.txt'

        stub_request(
          :get,
          url
        ).to_return(
          status: 307, headers: { location: redirection }
        )

        stub_request(
          :get,
          redirection
        ).to_return(
          body: file_fixture(body),
          status: status
        )
      end

      it 'follows the new url' do
        table = described_class.new url

        expect(table.rows.size).to eq(2)
        expect(table.rows).to match_array(
          [
            have_attributes(
              captured_at: Time.new(2020, 1, 31, 23, 0),
              stage: BigDecimal('1.234'),
              discharge: BigDecimal('0.78'),
              precipitation: nil
            ),
            have_attributes(
              captured_at: Time.new(2020, 1, 31, 22, 45),
              stage: BigDecimal('1.233'),
              discharge: BigDecimal('0.77'),
              precipitation: nil
            )
          ]
        )
      end
    end

    context 'when a timeout error occurs' do
      before do
        stub_request(
          :get,
          'https://ibwc.gov/gage_id.txt'
        ).to_timeout
      end

      after do
        WebMock.allow_net_connect!
      end

      it 'raises ConnectionError exception' do
        table = described_class.new url

        expect do
          table.rows
        end.to raise_error(GageScrapper::RemoteTable::ConnectionError)
      end
    end
  end

  describe '#error' do
    subject(:table) { described_class.new 'https://ibwc.gov/gage_id.txt' }

    context 'when http errors happens' do
      let(:body) { 'error.txt' }
      let(:status) { 500 }

      it 'returns http body error' do
        expect(table.error).to eq("An error occurred\n")
      end
    end

    context 'when no http errors happens' do
      let(:body) { 'error.txt' }
      let(:status) { 200 }

      it 'returns nil' do
        expect(table.error).to be nil
      end
    end
  end
end
