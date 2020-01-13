# frozen_string_literal: true

module BreezyPDFLite
  # Request conversion of a HTML string to PDF
  class RenderRequest
    def initialize(body)
      @body = body
    end

    def submit
      client.post("/render/html", @body)
    end

    def to_file
      raise BreezyPDFLiteError, "#{response.code}: #{response.body}" if response.code != "201"

      @to_file ||= Tempfile.new(%w[response .pdf]).tap do |file|
        file.binmode
        file.write response.body
        file.flush
        file.rewind
      end
    end

    private

    def response
      @response ||= submit
    end

    def client
      @client ||= Client.new
    end
  end
end
