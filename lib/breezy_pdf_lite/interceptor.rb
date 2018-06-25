# frozen_string_literal: true

module BreezyPDFLite
  # Intercept a Rack request
  class Interceptor
    attr_reader :app, :env

    def initialize(app, env)
      @app = app
      @env = env
    end

    def intercept!
      if intercept?
        intercept.new(@app, @env).call
      else
        app.call(env)
      end
    end

    private

    def intercept?
      get? && matching_uri?
    end

    def matching_uri?
      matchers.any? { |regex| env["REQUEST_URI"].match?(regex) }
    end

    def get?
      env["REQUEST_METHOD"].match?(/get/i)
    end

    def matchers
      @matchers ||= BreezyPDFLite.middleware_path_matchers
    end

    def intercept
      BreezyPDFLite::Intercept::HTML
    end
  end
end
