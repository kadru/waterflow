# frozen_string_literal: true

FactoryBot.define do
  factory :river do
    name { 'conchos' }
    sequence(:ibcw_id)
    url { 'http://example.com' }
    offset { 0 }

    factory :river_with_waterflows do
      transient do
        waterflows_count { 2 }
      end

      after :create do |river, evaluator|
        create_list(:waterflow, evaluator.waterflows_count, river: river)
      end
    end
  end
end
