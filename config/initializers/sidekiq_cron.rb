# frozen_string_literal: true

Sidekiq::Cron::Job.load_from_hash(Rails.application.config_for(:schedule)) if Sidekiq.server?
