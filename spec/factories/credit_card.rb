# frozen_string_literal: true

FactoryBot.define do
  factory :credit_card do
    account { build(:account) }

    pan { Faker::Finance.credit_card(:mastercard) }
    holder { Faker::Name.name }
    exp_month { Faker::Time.between(from: 1.year.from_now, to: 10.years.from_now).month }
    exp_year { Faker::Time.between(from: 1.year.from_now, to: 10.years.from_now).year }
  end
end
