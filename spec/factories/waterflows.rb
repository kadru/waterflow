# frozen_string_literal: true

FactoryBot.define do
  factory :waterflow do
    gage
    stage { 1.0 }
    discharge { 2.0 }
    sequence(:captured_at) do |n|
      Time.zone.local(2020, 1, 1, n, 0)
    end
  end
end
