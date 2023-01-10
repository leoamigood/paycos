# frozen_string_literal: true

class PaymentService
  def self.add_payment_method(payment_method)
    payment_method.save!

    payment_method
  end

  def charge(account, payment_method, payload)
    account.payments.create!(payload.merge(credit_card: payment_method))
  end
end
