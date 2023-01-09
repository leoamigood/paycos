# frozen_string_literal: true

module ControllerErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from NotFoundError do |error|
      not_found_error([error:, details: error.metadata])
    end

    rescue_from RailsParam::InvalidParameterError do |error|
      unprocessable_entity_error([error:, details: error.options])
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      unprocessable_entity_error([error:])
    end

    private

    def not_found_error(errors)
      json_errors(errors, :not_found)
    end

    def unprocessable_entity_error(errors)
      json_errors(errors, :unprocessable_entity)
    end

    def json_errors(errors, status)
      render json: { errors: }, status:
    end
  end
end
