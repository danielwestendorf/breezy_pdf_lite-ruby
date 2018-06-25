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

    private

    def client
      @client ||= Client.new
    end
  end
end
