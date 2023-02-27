# frozen_string_literal: true

require 'logger'
require 'sequel_wrap/connector'

RSpec.describe SequelWrap::Connector, skip_ci: true do
  let(:logger) do
    Logger.new('/dev/null')
  end

  describe '#connect' do
    context 'when DATABASE_URL env is set' do
      subject(:connector) do
        described_class.new(env: 'test', logger:)
      end

      around do |example|
        ENV['DATABASE_URL'] = 'postgresql:///postgres'
        example.run
        ENV.delete('DATABASE_URL')
      end

      it 'connects to DATABASE_URL database is pointing' do
        db = connector.connect

        expect(db.database_type).to eq(:postgres)
        expect(db.loggers).to eq([logger])
        expect(db.opts[:database]).to eq('postgres')
        expect(db.opts[:max_connections]).to eq(5)
      end
    end

    context 'when a valid env is given' do
      subject(:connector) do
        described_class.new env: 'test', logger:
      end

      it 'connects to the given env' do
        db = connector.connect

        expect(db.database_type).to eq(:postgres)
        expect(db.opts[:database]).to eq('waterflow_app_test')
        expect(db.loggers).to eq([logger])
        expect(db.opts[:max_connections]).to eq(5)
      end
    end

    context 'when a invalid env is given' do
      subject(:connector) do
        described_class.new env: 'non-enviroment', logger:
      end

      it 'raise an error' do
        expect do
          connector.connect
        end.to raise_error(KeyError)
      end
    end
  end
end
