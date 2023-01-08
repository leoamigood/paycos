# frozen_string_literal: true

require 'rails_helper'

describe Account do
  it 'creates an account' do
    expect { described_class.create! }.to change(described_class, :count).by(1)
  end
end
