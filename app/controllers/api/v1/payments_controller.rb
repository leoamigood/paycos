# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < BaseController
      before_action :validate_account

      def show
        param! :id, Integer, required: true

        transaction = Payment.find_by(account_id: @account.id, id: params[:id])
        raise NotFoundError.new('payment', transaction_id: params[:id]) if transaction.blank?

        render json: transaction.as_json(account_id: @account.id), status: :ok
      end

      def create
        param! :payment_method_id, Integer, required: true, message: 'Invalid payment method'
        param! :amount, Integer, min: 10, max: 100_000_00, required: true, message: 'Invalid payment amount'
        param! :description, String

        payment_method = CreditCard.find_by(id: params[:payment_method_id])
        raise NotFoundError.new('payment_method', payment_method_id: params[:payment_method_id]) if payment_method.blank?

        transaction = PaymentService.new.charge(@account, payment_method, params.permit(:amount, :description))
        render json: transaction.as_json(account_id: @account.id), status: :accepted
      end
    end
  end
end
