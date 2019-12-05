
# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "breezy_pdf_lite/version"

Gem::Specification.new do |spec|
  spec.name          = "breezy_pdf_lite"
  spec.version       = BreezyPDFLite::VERSION
  spec.authors       = ["Daniel Westendorf"]
  spec.email         = ["daniel@prowestech.com"]

  spec.summary       = "Ruby/rack middleware for BreezyPDF Lite. HTML to PDF."
  spec.license       = "GPLv3"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-stub-const", "~> 0.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "0.74.0"
end
