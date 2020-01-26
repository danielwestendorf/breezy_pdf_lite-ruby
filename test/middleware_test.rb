# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::MiddlewareTest < BreezyTest
  def test_a_post_request
    app = mock
    env = { "REQUEST_METHOD" => "post" }

    app.expects(:call).with(env)
    tested_class.new(app).call(env)
  end

  def test_a_get_request_with_invalid_path
    app = mock
    env = { "REQUEST_METHOD" => "get", "REQUEST_URI" => "/foo" }

    app.expects(:call).with(env)
    tested_class.new(app).call(env)
  end

  def test_a_get_request_with_valid_path
    app = proc { true }
    env = { "REQUEST_METHOD" => "get", "REQUEST_URI" => "/foo.pdf" }

    interceptor_mock = mock
    interceptor_mock.expects(:call)

    BreezyPDFLite::Interceptor.expects(:new).with(app, env).returns(interceptor_mock)
    tested_class.new(app).call(env)
  end
end
