# frozen_string_literal: true

module BreezyPDFLite
  # RenderRequest -> Net::HTTPResponse wrapper that is streaming compatable
  class Response
    def initialize(response)
      @response = response
    end

    def status
      @status ||= @response.code.to_i
    end

    def headers
      {
        "Content-Type" => "application/pdf",
        "Content-Length" => @response.header["Content-Length"],
        "Content-Disposition" => @response.header["Content-Disposition"]
      }
    end

    def each(&blk)
      @response.read_body(&blk)
    end

    def body
      io = StringIO.new
      io.binmode

      each do |chunk|
        io.write chunk
      end

      io.flush
      io.rewind

      io
    end
  end
end
