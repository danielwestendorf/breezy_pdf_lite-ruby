# frozen_string_literal: true

module BreezyPDFLite
  # :nodoc
  module Intercept
    UnRenderable = Class.new(BreezyPDFLiteError)
    autoload :Base, "breezy_pdf_lite/intercept/base"
    autoload :HTML, "breezy_pdf_lite/intercept/html"
  end
end
