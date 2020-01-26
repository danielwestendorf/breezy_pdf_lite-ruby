# frozen_string_literal: true

module BreezyPDFLite
  # Rack Middleware for BreezyPDFLite
  # Determines if the request should be intercepted or not
  class Middleware
    def initialize(app, _options = {})
      @app = app
    end

    def call(env)
      if intercept?(env)
        Interceptor.new(@app, env).call
      else
        @app.call(env)
      end
    end

    private

    # Is this request applicable?
    def intercept?(env)
      env["REQUEST_METHOD"].match?(/get/i) && matching_uri?(env)
    end

    def matching_uri?(env)
      BreezyPDFLite.middleware_path_matchers.any? do |regex|
        env["REQUEST_URI"].match?(regex)
      end
    end
  end
end
