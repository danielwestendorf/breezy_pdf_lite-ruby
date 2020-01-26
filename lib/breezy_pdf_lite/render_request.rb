# frozen_string_literal: true

module BreezyPDFLite
  # Request conversion of a HTML string to PDF
  # If the response isn't a 201, raise an error
  class RenderRequest
    def initialize(body)
      @body = body
    end

    def response
      @response ||= submit.tap do |resp|
        raise RenderError, "#{resp.code}: #{resp.body}" if resp.code != "201"
      end
    end

    def to_file
      @to_file ||= Tempfile.new(%w[response .pdf]).tap do |file|
        file.binmode
        file.write response.body
        file.flush
        file.rewind
      end
    end

    private

    def submit
      client.post("/render/html", @body)
    end

    def client
      @client ||= Client.new
    end
  end
end
