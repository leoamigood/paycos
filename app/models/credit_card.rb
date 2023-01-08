# frozen_string_literal: true

class CreditCard < ApplicationRecord
  belongs_to :account
  has_many :payments, dependent: :restrict_with_exception

  validates :pan, :holder, :exp_month, :exp_year, presence: true
  validates :exp_month, numericality: { only_integer: true, in: 1..12 }
  validates :exp_year, numericality: { only_integer: true, in: 1950..2100 }
end
