# frozen_string_literal: true

require 'swagger_helper'

describe 'Payment Method API' do
  path '/api/v1/accounts/{account_id}/payment_methods' do
    post('Add Payment Method') do
      tags 'Payment Method'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :account_id, in: :path, type: :integer

      parameter name: :payment_method, in: :body, schema: {
        type:       :object,
        properties: {
          payment_method_type: { type: :string, example: 'credit_card' },
          credit_card:         {
            type:       :object,
            properties: {
              pan:       { type: :string, example: '4111111111111111' },
              holder:    { type: :string, example: 'John Smith' },
              exp_month: { type: :integer, example: 3 },
              exp_year:  { type: :integer, example: 2030 }
            },
            required:   %w[pan holder exp_month exp_year]
          }
        },
        required:   %w[payment_method_type]
      }

      response 201, 'Credit Card Payment Method created' do
        schema type:       :object,
               properties: {
                 id:         { type: :integer, example: 1 },
                 account_id: { type: :integer, example: 1000 },
                 pan:        { type: :string, example: '4111****1111' },
                 holder:     { type: :string, example: 'John Smith' },
                 exp_month:  { type: :integer, example: 3 },
                 exp_year:   { type: :integer, example: 2030 }
               },
               required:   %w[account_id id pan holder exp_month exp_year]

        let(:account_id) { create(:account).id }
        let(:payment_method) do
          {
            payment_method_type: 'credit_card',
            credit_card:         build(:credit_card, pan: '4111111111111111')
          }
        end

        include_context 'with integration'
      end

      response 404, 'Account not found' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 0 }
        let(:payment_method) { 'not validated' }
        include_context 'with integration'
      end

      response 422, 'Account invalid' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { 'invalid' }
        let(:payment_method) { 'not validated' }
        include_context 'with integration'
      end

      response 422, 'Payment Method invalid' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { create(:account).id }
        let(:payment_method) do
          {
            payment_method_type: 'bitcoin',
            credit_card:         build(:credit_card)
          }
        end
        include_context 'with integration'
      end

      response 422, 'Credit Card not provided' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { create(:account).id }
        let(:payment_method) do
          {
            payment_method_type: 'credit_card'
          }
        end
        include_context 'with integration'
      end

      response 422, 'Credit Card required parameters not provided' do
        schema '$ref' => '#/components/schemas/errors_objects'

        let(:account_id) { create(:account).id }
        let(:payment_method) do
          {
            payment_method_type: 'credit_card',
            credit_card:         build(:credit_card, pan: nil)
          }
        end
        include_context 'with integration'
      end
    end

    get('List Payment Methods') do
      tags 'Payment Method'
      produces 'application/json'
      parameter name: :account_id, in: :path, type: :integer

      response 200, 'List stored Payment Methods' do
        schema type:       :object,
               properties: {
                 account_id:      { type: :integer, example: 1000 },
                 payment_methods: { type:       :object,
                                    properties: {
                                      credit_cards: {
                                        type:     :array,
                                        items:    {
                                          type:       :object,
                                          properties: {
                                            id:        { type: :integer, example: 1 },
                                            pan:       { type: :string, example: '4111****1111' },
                                            exp_month: { type: :integer, example: 3 },
                                            exp_year:  { type: :integer, example: 2030 }
                                          }
                                        },
                                        required: %w[id pan exp_month exp_year]
                                      }
                                    },
                                    required:   %w[credit_cards] }
               },
               required:   [:account_id]

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
