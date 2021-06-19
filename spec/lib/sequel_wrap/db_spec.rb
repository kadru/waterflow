# frozen_string_literal: true

require 'sequel_wrap/db'
require 'logger'
require 'byebug'

RSpec.describe SequelWrap::Db do
  let(:logger) { Logger.new('/dev/null') }

  subject do
    described_class.new env: 'test', logger: logger
  end

  describe 'lazy connect' do
    around do |example|
      ENV['DATABASE_URL'] = 'invalid-url'
      example.run
      ENV.delete('DATABASE_URL')
    end

    it 'connects to db until the first method call' do
      expect do
        described_class.new env: 'test', logger: logger
      end.to_not raise_error
    end
  end

  # Test that this method are delegated to Sequel::Database instance
  # there are more methods delegated but for convenience I will only test this
  describe '#[]' do
    it 'returns a dataset' do
      expect(subject[:users]).to be_kind_of(Sequel::Postgres::Dataset)
    end
  end
end
