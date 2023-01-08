# frozen_string_literal: true

require 'rails_helper'

describe CreditCard do
  let(:account) { create(:account) }

  it 'succeeds adding credit card for an account' do
    expect do
      account.credit_cards.create!(pan: '1234****3456', holder: 'John Smith', exp_month: 3, exp_year: 2030)
    end.to change(described_class, :count).by(1)
  end

  it 'passes validation when required fields present' do
    expect(described_class.new(account:, pan: '1234****3456', holder: 'John Smith', exp_month: 3, exp_year: 2030)).to be_valid
  end

  it 'fails validation when required fields missing' do
    expect(described_class.new(account:)).to be_invalid
  end

  it 'fails validation when month value is not integer' do
    expect(described_class.new(account:, exp_month: 7.5, pan: '1234****3456', holder: 'John Smith', exp_year: 2030)).to be_invalid
  end

  it 'fails validation when month value out of range' do
    expect(described_class.new(account:, exp_month: 13, pan: '1234****3456', holder: 'John Smith', exp_year: 2030)).to be_invalid
  end

  it 'fails validation when year value is not integer' do
    expect(described_class.new(account:, exp_year: 2022.2, pan: '1234****3456', holder: 'John Smith', exp_month: 3)).to be_invalid
  end

  it 'fails validation when year value is out of the range' do
    expect(described_class.new(account:, exp_year: 2030, pan: '1234****3456', holder: 'John Smith', exp_month: 123)).to be_invalid
  end

  context 'with credit card never used for a payment' do
    let!(:credit_card) { create(:credit_card, account:) }

    it 'succeeds removing credit card from an account' do
      expect { credit_card.destroy }.to change(described_class, :count).by(-1)
    end
  end

  context 'with credit card used for payment' do
    let!(:credit_card) { create(:credit_card, account:) }
    let!(:payment) { create(:payment, account:, credit_card:) }

    it 'fails removing credit card from an account' do
      expect { credit_card.destroy }.to raise_exception ActiveRecord::DeleteRestrictionError
    end
  end
end
