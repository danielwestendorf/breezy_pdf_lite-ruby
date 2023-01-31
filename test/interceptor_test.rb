# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::InterceptorTest < BreezyTest
  def app
    @app ||= mock("app")
  end

  def test_app_receives_doctored_env
    env = {"PATH_INFO" => "/foo.pdf"}
    doctored_env = {"HTTP_ACCEPT" => "text/html", "PATH_INFO" => "/foo"}
    response = ["301", {}, ["body"]]

    app.expects(:call).with(doctored_env).returns(response)
    tested_class.new(app, env).call
  end

  def test_non_2xx_app_response_returns_app_response
    env = {"PATH_INFO" => "/foo.pdf"}
    response = ["404", {}, ["body"]]

    app.expects(:call).returns(response)
    assert_equal response, tested_class.new(app, env).call
  end

  def test_response_body_is_array
    env = {"PATH_INFO" => "/foo.pdf"}
    response = ["200", {}, %w[body bar]]

    html_intercept_mock = mock("html intercept")
    html_intercept_mock.expects(:call).returns(true)

    BreezyPDFLite::Intercept::HTML.expects(:new).with(response[2].join).returns(html_intercept_mock)

    app.expects(:call).returns(response)
    assert tested_class.new(app, env).call
  end

  def test_response_body_is_eachable
    response_body_mock = mock("response body")
    response_body_mock.expects(:each).yields("FooBar")

    env = {"PATH_INFO" => "/foo.pdf"}
    response = ["200", {}, response_body_mock]

    html_intercept_mock = mock("html intercept")
    html_intercept_mock.expects(:call).returns(true)

    BreezyPDFLite::Intercept::HTML.expects(:new).with("FooBar").returns(html_intercept_mock)

    app.expects(:call).returns(response)
    assert tested_class.new(app, env).call
  end
end
