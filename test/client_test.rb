# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::ClientTest < BreezyTest
  def test_post
    body = "bob"
    http_mock = MiniTest::Mock.new
    request_mock = MiniTest::Mock.new
    request_mock.expect(:body=, true, [body])

    http_mock.expect(:tap, http_mock)
    http_mock.expect(:request, OpenStruct.new(code: "201"), [request_mock])

    Net::HTTP.stub(:new, http_mock) do
      Net::HTTP::Post.stub(:new, request_mock) do
        tested_class.new.post("/test", body)
      end
    end

    assert http_mock.verify
    assert request_mock.verify
  end
end
