# frozen_string_literal: true

module BreezyPDFLite::Intercept
  # :nodoc
  class Base
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end
end
