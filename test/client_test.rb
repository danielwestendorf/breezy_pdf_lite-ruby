# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::ClientTest < BreezyTest
  def test_post
    body = "bob"
    path = "/foo"
    uri = URI.parse(BreezyPDFLite.base_url + path)
    headers = {
      "Authorization": "Bearer #{BreezyPDFLite.secret_api_key}"
    }

    request_mock = mock("Request")
    request_mock.expects(:body=).with(body)

    http_mock = mock("HTTP")
    http_mock.expects(:use_ssl=).with(true)
    http_mock.expects(:open_timeout=).with(BreezyPDFLite.open_timeout)
    http_mock.expects(:read_timeout=).with(BreezyPDFLite.read_timeout)
    http_mock.expects(:request).with(request_mock)

    Net::HTTP.expects(:new).returns(http_mock)
    Net::HTTP::Post.expects(:new).with(uri.request_uri, headers).returns(request_mock)

    tested_class.new.post(path, body)
  end
end
