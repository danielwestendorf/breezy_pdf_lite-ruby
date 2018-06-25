# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::MiddlewareTest < BreezyTest
  def test_invokes_interceptor
    mock_intercept = MiniTest::Mock.new
    mock_intercept.expect(:intercept!, true)

    mock_interceptor = MiniTest::Mock.new
    mock_interceptor.expect(:new, mock_intercept, [1, 2])

    BreezyPDFLite.stub_const(:Interceptor, mock_interceptor) do
      tested_class.new(1).call(2)
    end

    assert mock_interceptor.verify
    assert mock_intercept.verify
  end
end
