# frozen_string_literal: true

require 'swagger_helper'

describe 'Payments API' do
  path '/api/v1/accounts/{account_id}/payments' do
    post('Charge Credit Card') do
      tags 'Payment'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :account_id, in: :path, type: :integer

      parameter name: :payment, in: :body, schema: {
        type:       :object,
        properties: {
          payment_method_id: { type: :integer, example: 1 },
          amount:            { type: :integer, example: 200 },
          description:       { type: :string }
        },
        required:   %w[payment_method_id amount]
      }

      response 202, 'Credit Card charge accepted' do
        schema type:       :object,
               properties: {
                 account_id:     { type: :integer, example: 1000 },
                 transaction_id: { type: :integer, example: 1 },
                 created_at:     { type: :string, example: '2023-01-10T05:11:00.802Z' }
               },
               required:   %w[account_id transaction_id created_at]

        let(:account_id) { create(:account).id }
        let(:payment_method_id) { create(:credit_card).id }
        let(:payment) { { payment_method_id:, amount: 200, description: 'Test charge' } }

        include_context 'with integration'
      end

      response 404, 'Account not found' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 0 }
        let(:payment_method_id) { 'not validated' }
        let(:payment) { { payment_method_id:, amount: 200, description: 'Test charge' } }

        include_context 'with integration'
      end

      response 422, 'Account invalid' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 'invalid' }
        let(:payment_method_id) { 'not validated' }
        let(:payment) { { payment_method_id:, amount: 200, description: 'Test charge' } }

        include_context 'with integration'
      end
    end
  end

  path '/api/v1/accounts/{account_id}/payments/{id}' do
    get('Payment Status') do
      tags 'Payment'
      produces 'application/json'
      parameter name: :account_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      response 200, 'Get Transaction by ID' do
        schema type:       :object,
               properties: {
                 account_id:     { type: :integer, example: 1000 },
                 transaction_id: { type: :integer, example: 1 },
                 amount:         { type: :integer, example: 650 },
                 created_at:     { type: :string, example: '2023-01-10T05:11:00.802Z' }
               },
               required:   %w[account_id transaction_id amount created_at]

        let(:account_id) { create(:account).id }
        let(:id) { create(:payment, account_id:).id }

        include_context 'with integration'
      end

      response 404, 'Account not found' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 0 }
        let(:id) { 1 }
        include_context 'with integration'
      end

      response 422, 'Account invalid' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 'invalid' }
        let(:id) { 1 }
        include_context 'with integration'
      end
    end
  end
end
