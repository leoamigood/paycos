# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :credit_cards, dependent: :restrict_with_exception
  has_many :payments, dependent: :restrict_with_exception
end
