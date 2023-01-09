# frozen_string_literal: true

class NotFoundError < ApiError
  def initialize(entity, metadata = {})
    super(entity, :not_found, metadata)
  end

  def code_for(entity)
    "#{entity&.downcase}_not_found"
  end
end
