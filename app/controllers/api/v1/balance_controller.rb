# frozen_string_literal: true

module Api
  module V1
    class BalanceController < BaseController
      before_action :validate_account

      def index
        balance = Payment.where(account_id: @account).sum(:amount)

        render json: { account_id: @account.id, balance:, created_at: DateTime.now }, status: :ok
      end
    end
  end
end
