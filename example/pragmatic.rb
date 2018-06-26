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

response = BreezyPDFLite::RenderRequest.new(html).submit

if response.code.to_i == 201
  path = File.expand_path("example.pdf", __dir__)

  FileUtils.rm(File.expand_path("example.pdf", __dir__)) if File.exist?(path)
  File.new(path, "w").tap do |file|
    file.write(response.body)

    file.flush
    file.close
  end

  puts "Downloaded to #{path}"
else
  puts "Unable to render to PDF, server responded with #{response.code}"
end
