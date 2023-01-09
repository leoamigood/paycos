# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include ControllerErrorHandler
      def validate_account
        param! :account_id, Integer, required: true, message: 'Invalid account'

        @account = Account.find_by(id: params[:account_id])
        raise NotFoundError.new('account', account_id: params[:account_id]) if @account.blank?
      end

      def lowercase_params
        params.deep_transform_keys!(&:downcase)
      end
    end
  end
end
