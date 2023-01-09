# frozen_string_literal: true

module Api
  module V1
    class PaymentMethodsController < BaseController
      include PaymentMethodValidator

      before_action :lowercase_params
      before_action :validate_account

      def index
        cards = CreditCard.where(account: @account).all
        render json: payment_methods(@account, cards), status: :ok
      end

      def create
        validate_payment_method_params

        payment_method = validate_payment_method
        return validation_errors(payment_method) unless payment_method.valid?

        credit_card = PaymentService.add_payment_method(payment_method)
        render json: credit_card.as_json(account_id: @account.id), status: :created
      end

      private

      def validate_payment_method_params
        param! :account_id, Integer, required: true, message: 'Invalid account'
        param! :payment_method_type, String, required: true, message: 'Invalid payment method'
      end

      def validate_credit_card_params
        param! :credit_card, Hash, required: true do |b|
          b.param! :pan, String, blank: false, required: true, message: 'Invalid credit card number'
          b.param! :holder, String, blank: false, required: true, message: 'Invalid credit card holder name'
          b.param! :exp_month, Integer, in: 1..12, required: true, message: 'Invalid expiration month'
          b.param! :exp_year, Integer, in: valid_expiration_year, required: true, message: 'Invalid expiration year'
        end
      end

      def valid_expiration_year(now = DateTime.now)
        now.year..10.years.from_now.year
      end

      def validation_errors(entity)
        errors = entity.errors.map do |error|
          case error.attribute
          when :pan
            validate_credit_card(error)
          when :payment_method_type
            { error: 'Invalid Payment Method type', details: { payment_method_type: entity.type } }
          else
            error
          end
        end

        json_errors(errors, :unprocessable_entity)
      end

      def payment_methods(account, cards)
        { account_id: account.id }.merge(payment_methods: { credit_cards: cards })
      end
    end
  end
end
