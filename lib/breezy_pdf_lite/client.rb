# frozen_string_literal: true

module BreezyPDFLite
  # HTTP Client for BreezyPDFLite API
  class Client
    def post(path, body)
      uri = URI.parse(BreezyPDFLite.base_url + path)
      http = Net::HTTP.new(uri.host, uri.port).tap { |h| h.use_ssl = true }
      request = Net::HTTP::Post.new(uri.request_uri, headers)

      request.body = body

      http.request(request)
    end

    private

    def headers
      {
        "Authorization": "Bearer #{BreezyPDFLite.secret_api_key}"
      }
    end
  end
end
