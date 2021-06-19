# frozen_string_literal: true

require 'sequel_wrap'

# db = SequelConnector.new(env: Rails.env, logger: Rails.logger).connect_database
DB = SequelWrap::Db.new(env: Rails.env, logger: Rails.logger)
