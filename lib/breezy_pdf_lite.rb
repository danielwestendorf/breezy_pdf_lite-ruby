# frozen_string_literal: true

require "uri"
require "net/http"
require "tempfile"

require "breezy_pdf_lite/version"
require "breezy_pdf_lite/util"

# :nodoc
module BreezyPDFLite
  extend BreezyPDFLite::Util

  autoload :Client, "breezy_pdf_lite/client"
  autoload :Intercept, "breezy_pdf_lite/intercept"
  autoload :Interceptor, "breezy_pdf_lite/interceptor"
  autoload :Middleware, "breezy_pdf_lite/middleware"
  autoload :RenderRequest, "breezy_pdf_lite/render_request"

  Error = Class.new(StandardError)
  RenderError = Class.new(Error)

  mattr_accessor :secret_api_key
  @@secret_api_key = nil

  mattr_accessor :base_url
  @@base_url = "https://localhost:5001/"

  mattr_accessor :middleware_path_matchers
  @@middleware_path_matchers = [/\.pdf/]

  mattr_accessor :open_timeout
  @@open_timeout = 30

  mattr_accessor :read_timeout
  @@read_timeout = 30

  def self.setup
    yield self
  end
end
