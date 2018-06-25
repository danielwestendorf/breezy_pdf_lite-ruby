# frozen_string_literal: true

module BreezyPDFLite
  # Rack Middleware for BreezyPDFLite
  class Middleware
    def initialize(app, _options = {})
      @app = app
    end

    def call(env)
      Interceptor.new(@app, env).intercept!
    end
  end
end
