# frozen_string_literal: true

class ApiError < StandardError
  attr_reader :code, :status, :metadata

  def initialize(code, status, metadata = {})
    @status = status
    @metadata = metadata

    super(message_for(code))
  end

  def code_for(key)
    key
  end

  def message_for(key)
    I18n.t("errors.#{code_for(key)}")
  end

  def message
    return metadata unless metadata.is_a? Hash

    metadata[:message].presence || super
  end
end
