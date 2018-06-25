# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::RenderRequestTest < BreezyTest
  def test_submit
    client_mock = MiniTest::Mock.new
    client_mock.expect(
      :post,
      "Success",
      ["/render/html", "blah"]
    )

    request = tested_class.new("blah")
    request.stub(:client, client_mock) do
      assert_equal("Success", request.submit)
    end

    assert client_mock.verify
  end
end
