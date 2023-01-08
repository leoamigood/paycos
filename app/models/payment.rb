# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :account
  belongs_to :credit_card

  validates :amount, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
end
