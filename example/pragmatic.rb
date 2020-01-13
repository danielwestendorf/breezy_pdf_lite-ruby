# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "breezy_pdf_lite"
require "fileutils"

html = File.read(File.expand_path("ex.html", __dir__))

BreezyPDFLite.setup do |config|
  config.secret_api_key = ENV["BREEZYPDF_SECRET_API_KEY"]
  config.base_url = ENV.fetch("BREEZYPDF_BASE_URL", "http://localhost:5001")
  config.middleware_path_matchers = [/as-pdf.pdf/]
end

render_request = BreezyPDFLite::RenderRequest.new(html)

begin
  tempfile = render_request.to_file
  puts tempfile.path
  puts "Enter to remove..."
  gets
rescue BreezyPDFLite::BreezyPDFLiteError => e
  puts "Unable to render PDF: #{e.message}"
end
