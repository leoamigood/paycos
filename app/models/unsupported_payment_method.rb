# frozen_string_literal: true

class UnsupportedPaymentMethod
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def errors
    [ActiveModel::Error.new(self, :payment_method_type)]
  end

  def valid?
    false
  end
end
