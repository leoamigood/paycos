# frozen_string_literal: true

class PaymentService
  def self.add_payment_method(payment_method)
    payment_method.save!

    payment_method
  end
end
