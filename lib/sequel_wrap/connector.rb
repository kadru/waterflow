# frozen_string_literal: true

require 'sequel'

module SequelWrap
  # Configures sequel to connect to db based in DATABASE_URL or database.yml, will prioritize DATABASE_URL
  # Also configures and freeze the db instance
  # Appends a logger and load pg_streaming extension
  class Connector
    # @param env [String]
    # @param logger [Logger]
    def initialize(env:, logger:)
      @database_url = ENV['DATABASE_URL']
      @params = database_url ? {} : read_database_config(env)
      @logger = logger
    end

    # @return [Sequel::Database]
    def connect
      db = select_connection
      db.extension :pg_streaming
      db.loggers << logger
      db.freeze
      db
    end

    private

    attr_reader :logger, :params, :database_url

    def select_connection
      if database_url.nil?
        Sequel.connect(
          adapter: adapter,
          host: params['host'],
          database: params['database'],
          user: params['user'],
          password: params['password']
        )
      else
        Sequel.connect(database_url)
      end
    end

    # Sequel adapter name for PostgreSQL is postgres and for ActiveRecord is postgresql
    def adapter
      @params['adapter'].sub('postgresql', 'postgres')
    end

    def read_database_config(env)
      config_file = File.expand_path('./config/database.yml')
      database_config = File.open(config_file) { |file| YAML.safe_load(file, aliases: true) }

      database_config.fetch(env)
    end
  end
end
