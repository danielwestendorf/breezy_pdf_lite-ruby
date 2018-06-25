# frozen_string_literal: true

module BreezyPDFLite::Intercept
  # :nodoc
  class Base
    attr_reader :app, :env

    def initialize(app, env)
      @app = app
      @env = env
    end

    private

    def rendered_url
      "#{base_url}#{path}#{query_string}"
    end

    def requested_url
      "#{env['rack.url_scheme']}://#{env['SERVER_NAME']}#{port}" \
      "#{env['PATH_INFO']}#{query_string}"
    end

    def base_url
      "#{env['rack.url_scheme']}://#{env['SERVER_NAME']}#{port}"
    end

    def port
      ":#{env['SERVER_PORT']}" unless [80, 443].include?(env["SERVER_PORT"].to_i)
    end

    def path
      BreezyPDFLite.middleware_path_matchers.reduce(env["PATH_INFO"]) do |path, matcher|
        path.gsub(matcher, "")
      end
    end

    def query_string
      return "" if env["QUERY_STRING"].nil?

      env["QUERY_STRING"] == "" ? "" : "?#{env['QUERY_STRING']}"
    end
  end
end
