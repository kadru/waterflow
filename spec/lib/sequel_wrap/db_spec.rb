# frozen_string_literal: true

require 'sequel_wrap/db'
require 'logger'
require 'byebug'

RSpec.describe SequelWrap::Db do
  subject(:db) do
    described_class.new env: 'test', logger:
  end

  let(:logger) { Logger.new('/dev/null') }

  describe 'lazy connect' do
    around do |example|
      database_url = ENV['DATABASE_URL']
      ENV['DATABASE_URL'] = 'invalid-url'
      example.run
      ENV['DATABASE_URL'] = database_url
    end

    it 'connects to db until the first method call' do
      expect do
        described_class.new env: 'test', logger:
      end.not_to raise_error
    end
  end

  # Test that this method are delegated to Sequel::Database instance
  # there are more methods delegated but for convenience I will only test this
  describe '#[]' do
    it 'returns a dataset' do
      expect(db[:users]).to be_kind_of(Sequel::Postgres::Dataset)
    end
  end
end
