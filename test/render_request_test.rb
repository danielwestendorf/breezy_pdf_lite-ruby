# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::RenderRequestTest < BreezyTest
  def client_mock
    @client_mock ||= mock("Client")
  end

  def response_mock
    @response_mock ||= mock("Client response")
  end

  def test_response_successful
    body = "foo"

    response_mock.expects(:code).returns("201")
    client_mock.expects(:post).with("/render/html", body).returns(response_mock)

    BreezyPDFLite::Client.expects(:new).returns(client_mock)

    tested_class.new(body).response
  end

  def test_response_unsuccessful
    body = "foo"

    response_mock.expects(:code).returns("500").twice
    response_mock.expects(:body).returns("error")
    client_mock.expects(:post).with("/render/html", body).returns(response_mock)

    BreezyPDFLite::Client.expects(:new).returns(client_mock)

    assert_raises(BreezyPDFLite::RenderError) do
      tested_class.new(body).response
    end
  end

  def test_to_file
    body = "foo"

    response_mock.expects(:code).returns("201")
    response_mock.expects(:body).returns("body")
    client_mock.expects(:post).with("/render/html", body).returns(response_mock)

    BreezyPDFLite::Client.expects(:new).returns(client_mock)

    assert_kind_of Tempfile, tested_class.new(body).to_file
  end
end
