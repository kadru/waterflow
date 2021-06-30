# frozen_string_literal: true

require 'sequel_wrap/connector'

module SequelWrap
  # Sequel db decorator to allow lazy connection
  class Db < Delegator
    # @param logger [Logger]
    # @param env [String]
    def initialize(env:, logger:)
      @logger = logger
      @env = env
    end

    private

    attr_reader :env, :logger

    def __getobj__
      @__getobj__ ||= Connector.new(env: env, logger: logger).connect
    end
  end
end
