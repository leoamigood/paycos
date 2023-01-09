# frozen_string_literal: true

module PaymentMethodValidator
  extend ActiveSupport::Concern

  CREDIT_CARD = 'credit_card'

  included do
    def validate_payment_method
      case params[:payment_method_type]
      when CREDIT_CARD
        validate_credit_card_params
        CreditCard.build(params[:credit_card].permit(:pan, :holder, :exp_month, :exp_year)).with(account: @account)
      else
        UnsupportedPaymentMethod.new(params[:payment_method_type])
      end
    end

    def validate_credit_card(error)
      case error.type
      when :invalid
        { error: 'Invalid credit card number' }
      when :taken
        { error: 'Duplicate credit card', details: error.options }
      end
    end
  end
end
