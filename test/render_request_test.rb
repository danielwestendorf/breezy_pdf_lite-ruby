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

  def test_non_201_to_file
    request = tested_class.new("blah")

    request.stub(:submit, OpenStruct.new(code: "404")) do
      assert_raises(BreezyPDFLite::BreezyPDFLiteError) do
        request.to_file
      end
    end
  end

  def test_to_file
    request = tested_class.new("blah")

    request.stub(:submit, OpenStruct.new(code: "201", body: "blah")) do
      assert_kind_of(Tempfile, request.to_file)
    end
  end
end
