# frozen_string_literal: true

module Api
  module V1
    class PaymentMethodsController < BaseController
      include PaymentMethodValidator

      before_action :validate_account

      def index
        cards = CreditCard.where(account: @account).all
        render json: payment_methods(@account, cards), status: :ok
      end

      def create
        param! :payment_method_type, String, required: true, message: 'Invalid payment method'

        payment_method = validate_payment_method
        return validation_errors(payment_method) unless payment_method.valid?

        credit_card = PaymentService.add_payment_method(payment_method)
        render json: credit_card.as_json(account_id: @account.id), status: :created
      end

      private

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
