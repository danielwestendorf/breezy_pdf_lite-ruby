# frozen_string_literal: true

module BreezyPDFLite
  # Intercept a Rack request, determining if the app's response should
  # be intercepted or simply returned
  class Interceptor
    attr_reader :app, :env

    def initialize(app, env)
      @app = app
      @env = env
    end

    def call
      if (200..299).cover?(app_response_status) # Did the app respond well?
        Intercept::HTML.new(app_response_body).call # Try to return a PDF
      else
        app_response # Bad app response, just send respond with that
      end
    end

    private

    def app_response
      @app_response ||= app.call(doctored_env)
    end

    def app_response_status
      @app_response_status ||= app_response[0].to_i
    end

    def app_response_headers
      @app_response_headers ||= app_response[1]
    end

    def app_response_body
      if app_response[2].respond_to?(:join)
        app_response[2].join
      elsif app_response[2].respond_to?(:each)
        content = []
        app_response[2].each { |part| content << part }

        content.join
      else
        app_response[2]
      end
    end

    def doctored_env
      env.dup.tap do |hash|
        hash["HTTP_ACCEPT"] = "text/html"
        hash["PATH_INFO"] = path
      end
    end

    def path
      env["PATH_INFO"].gsub(/\.pdf/, "")
    end
  end
end
