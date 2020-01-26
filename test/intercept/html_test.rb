# frozen_string_literal: true

require "test_helper"
require "rack/request"
require "rack/file"

class BreezyPDFLite::Intercept::HTMLTest < BreezyTest
  def request_mock
    @request_mock ||= mock("Rack::Request")
  end

  def response_mock
    @response_mock ||= mock("render request response")
  end

  def mock_rack_file
    @mock_rack_file ||= mock("Rack::File")
  end

  def render_request_instance_mock
    @render_request_instance_mock ||= mock("RenderRequest instance")
  end

  def test_responds_with_file
    body = "Foobar"
    file = Tempfile.new
    headers = {
      "Content-Disposition" => "blah"
    }
    response_headers = {
      "Content-Type" => "application/pdf",
      "Content-Disposition" => headers["Content-Disposition"]
    }

    response_mock.expects(:header).returns(headers)
    mock_rack_file.expects(:serving).with(request_mock, file.path)

    render_request_instance_mock.expects(:response).returns(response_mock)
    render_request_instance_mock.expects(:to_file).returns(file)

    BreezyPDFLite::RenderRequest.expects(:new).with(body).returns(render_request_instance_mock)

    Rack::Request.expects(:new).returns(request_mock)
    Rack::File.expects(:new).with(file.path, response_headers).returns(mock_rack_file)

    tested_class.new(body).call
  end
end
