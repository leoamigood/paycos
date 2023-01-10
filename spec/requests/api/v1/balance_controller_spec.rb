# frozen_string_literal: true

require 'swagger_helper'

describe 'Payments API' do
  path '/api/v1/accounts/{account_id}/balance' do
    get('Account Balance') do
      tags 'Balance'
      produces 'application/json'
      parameter name: :account_id, in: :path, type: :integer

      response 200, 'Total Balance for Account' do
        schema type:       :object,
               properties: {
                 account_id: { type: :integer, example: 1000 },
                 balance:    { type: :integer, example: 650 },
                 created_at: { type: :datetime }
               },
               required:   %w[account_id balance created_at]

        let(:account_id) { create(:account).id }

        include_context 'with integration'
      end

      response 404, 'Account not found' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 0 }
        include_context 'with integration'
      end

      response 422, 'Account invalid' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 'invalid' }
        include_context 'with integration'
      end
    end
  end
end
