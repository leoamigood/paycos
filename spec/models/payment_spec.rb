# frozen_string_literal: true

require 'rails_helper'

describe Payment do
  context 'with unused credit card on account' do
    let!(:account) { create(:account) }
    let!(:credit_card) { create(:credit_card) }

    it 'passes validation when all required fields present' do
      expect(described_class.new(account:, credit_card:, amount: 200)).to be_valid
    end

    it 'passes validation when all required and optional fields present' do
      expect(described_class.new(account:, credit_card:, amount: 200, description: 'Test payment')).to be_valid
    end

    it 'fails validation when any required fields missing' do
      expect(described_class.new(account:, credit_card:)).to be_invalid
    end

    it 'fails validation when payment amount is non integer' do
      expect(described_class.new(account:, credit_card:, amount: 0.5)).to be_invalid
    end

    it 'fails validation when payment amount is non positive' do
      expect(described_class.new(account:, credit_card:, amount: 0)).to be_invalid
      expect(described_class.new(account:, credit_card:, amount: -100)).to be_invalid
    end
  end
end
