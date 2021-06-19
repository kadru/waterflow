# frozen_string_literal: true

require 'logger'
require 'sequel_wrap/connector'

RSpec.describe SequelWrap::Connector do
  let(:logger) do
    Logger.new('/dev/null')
  end

  describe '#connect' do
    context 'when DATABASE_URL env is set' do
      around do |example|
        ENV['DATABASE_URL'] = 'postgresql:///postgres'
        example.run
        ENV.delete('DATABASE_URL')
      end

      subject do
        described_class.new(env: 'test', logger: logger)
      end

      it 'connects to DATABASE_URL database is pointing' do
        db = subject.connect

        expect(db.database_type).to eq(:postgres)
        expect(db.loggers).to eq([logger])
        expect(db.opts[:database]).to eq('postgres')
      end
    end

    context 'when a valid env is given' do
      subject do
        described_class.new env: 'test', logger: logger
      end

      it 'connects to the given env' do
        db = subject.connect

        expect(db.database_type).to eq(:postgres)
        expect(db.opts[:database]).to eq('waterflow_app_test')
        expect(db.loggers).to eq([logger])
      end
    end

    context 'when a invalid env is given' do
      subject do
        described_class.new env: 'non-enviroment', logger: logger
      end

      it 'raise an error' do
        expect do
          subject.connect
        end.to raise_error(KeyError)
      end
    end
  end
end
