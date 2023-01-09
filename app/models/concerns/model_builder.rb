# frozen_string_literal: true

module ModelBuilder
  extend ActiveSupport::Concern

  class_methods do
    def build(attributes)
      new(attributes)
    end
  end

  included do
    def with(attributes)
      assign_attributes(attributes)
      self
    end
  end
end
