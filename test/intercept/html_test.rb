# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::Intercept::HTMLTest < BreezyTest
  def app_response
    [201, {}, ["body"]]
  end

  def mocks
    response = OpenStruct.new(
      header: {
        "Content-Length" => 1234
      },
      body: StringIO.new
    )

    mock_submit = MiniTest::Mock.new
    mock_submit.expect(:submit, response)

    mock_request = MiniTest::Mock.new
    mock_request.expect(:new, mock_submit, app_response[2])

    mock_app = MiniTest::Mock.new
    mock_app.expect(:call, app_response, [{ "PATH_INFO" => "/xyz", "HTTP_ACCEPT" => "text/html" }])

    [mock_request, mock_submit, mock_app]
  end

  def test_responds_with_pdf
    mock_request, mock_submit, mock_app = mocks

    BreezyPDFLite.stub_const(:RenderRequest, mock_request) do
      status, headers, body = tested_class.new(mock_app, "PATH_INFO" => "/xyz.pdf").call

      assert_equal 201, status
      assert_equal 1234, headers["Content-Length"]
      assert_equal "application/pdf", headers["Content-Type"]
      assert_kind_of Array, body
    end

    assert mock_request.verify
    assert mock_submit.verify
    assert mock_app.verify
  end

  def test_non_successful_app_response
    mock_app = MiniTest::Mock.new
    mock_app.expect(
      :call,
      [301, { "Location" => "/xyz" }, [""]],
      [{ "PATH_INFO" => "/xyz", "HTTP_ACCEPT" => "text/html" }]
    )

    status, headers, _body = tested_class.new(mock_app, "PATH_INFO" => "/xyz.pdf").call

    assert_equal 301, status
    assert_equal "/xyz", headers["Location"]

    assert mock_app.verify
  end
end
