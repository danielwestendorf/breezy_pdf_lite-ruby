# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "breezy_pdf_lite"

html = File.read(File.expand_path("ex.html", __dir__))

BreezyPDFLite.setup do |config|
  config.secret_api_key = ENV["BREEZYPDF_SECRET_API_KEY"]
  config.base_url = ENV.fetch("BREEZYPDF_BASE_URL", "http://localhost:5001")
  config.middleware_path_matchers = [/as-pdf.pdf/]
end

use BreezyPDFLite::Middleware
run(proc { |_env| ["200", {"Content-Type" => "text/html"}, [html]] })
