# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    account { build(:account) }
    credit_card { build(:credit_card) }

    amount { Faker::Number.between(from: 10, to: 100_000 * 100) }
    description { Faker::Lorem.sentence }
  end
end
