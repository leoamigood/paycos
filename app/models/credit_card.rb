# frozen_string_literal: true

class CreditCard < ApplicationRecord
  include ModelBuilder

  belongs_to :account
  has_many :payments, dependent: :restrict_with_exception

  after_initialize -> { mask unless new_record? }
  after_save -> { mask }

  validates :holder, :exp_month, :exp_year, presence: true
  validates :exp_month, numericality: { only_integer: true, in: 1..12 }
  validates :exp_year, numericality: { only_integer: true, in: 1950..2100 }
  validates :pan, uniqueness: { scope: :account_id }
  validates :pan, presence: true, credit_card_number: true

  def as_json(options = {})
    {
      account_id: options[:account_id],
      id:,
      pan:        options[:mask] ? pan && mask(pan) : pan,
      holder:,
      exp_month:,
      exp_year:
    }.compact
  end

  private

  def mask
    self.pan = "#{pan[0..3]}****#{pan[-4..]}"
  end
end
