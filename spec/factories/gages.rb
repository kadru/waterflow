# frozen_string_literal: true

FactoryBot.define do
  factory :gage do
    name { 'conchos' }
    sequence(:ibcw_id)
    url { 'http://example.com' }
    offset { 0 }

    factory :gage_with_waterflows do
      transient do
        waterflows_count { 2 }
      end

      after :create do |gage, evaluator|
        create_list(:waterflow, evaluator.waterflows_count, gage: gage)
      end
    end
  end
end
