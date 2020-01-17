# frozen_string_literal: true

module BreezyPDFLite::Intercept
  # :nodoc
  class HTML < Base
    def call
      raise BreezyPDFLite::Intercept::UnRenderable unless (200..299).cover?(status)

      render_request = BreezyPDFLite::RenderRequest.new(body).submit

      expires = (Time.now.utc + (60 * 10)).strftime("%a, %e %b %Y %H:%M:%S GMT")
      timestamp = Time.now.utc.to_i
      download_key = Rack::Utils.parse_query(env["QUERY_STRING"])["download_key"]

      headers = {
        "Content-Type" => "application/pdf",
        "Content-Length" => render_request.header["Content-Length"],
        "Content-Disposition" => render_request.header["Content-Disposition"]
      }

      headers["Set-Cookie"] = "breezy_pdf_downloaded_#{download_key}=#{timestamp}; Expires=#{expires}" if download_key

      [
        201,
        headers,
        [render_request.body]
      ]
    rescue BreezyPDFLite::Intercept::UnRenderable
      response
    end

    private

    def status
      @status ||= response[0].to_i
    end

    def headers
      @headers ||= response[1]
    end

    def body
      @body ||= response[2].respond_to?(:body) ? response[2].body : response[2].join
    end

    def response
      @response ||= app.call(doctored_env)
    end

    def doctored_env
      env.dup.tap do |hash|
        hash["HTTP_ACCEPT"] = "text/html"
        hash["PATH_INFO"]   = path
      end
    end
  end
end
