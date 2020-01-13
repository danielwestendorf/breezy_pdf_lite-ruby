# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::InterceptorTest < BreezyTest
  def test_non_matching_uri
    env = {
      "REQUEST_URI" => "/thing",
      "REQUEST_METHOD" => "GET"
    }

    app = MiniTest::Mock.new
    app.expect(:call, true, [env])

    tested_class.new(app, env).intercept!

    assert app.verify
  end

  def test_non_matching_method
    env = {
      "REQUEST_METHOD" => "POST"
    }

    app = MiniTest::Mock.new
    app.expect(:call, true, [env])

    tested_class.new(app, env).intercept!

    assert app.verify
  end

  def test_matching_uri_and_method_for_html_post
    app = OpenStruct.new(call: true)
    env = {
      "REQUEST_URI" => "/thing.pdf",
      "REQUEST_METHOD" => "GET",
      "rack.url_scheme" => "https",
      "SERVER_NAME" => "example.com",
      "SERVER_PORT" => "443",
      "PATH_INFO" => "/thing.pdf",
      "QUERY_STRING" => "a=b"
    }

    intercept_mock = MiniTest::Mock.new
    intercept_mock.expect(:new, OpenStruct.new(call: []), [app, env])

    BreezyPDFLite::Intercept.stub_const(:HTML, intercept_mock) do
      tested_class.new(app, env).intercept!
    end

    assert intercept_mock.verify
  end
end
