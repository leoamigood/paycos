# frozen_string_literal: true

require 'swagger_helper'

describe 'Account API' do
  path '/api/v1/accounts' do
    post('Create Account') do
      tags 'Account'

      produces 'application/json'
      consumes 'application/json'

      response(201, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        include_context 'with integration'
      end
    end
  end
end
