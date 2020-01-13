# frozen_string_literal: true

require "test_helper"

class BreezyPDFLite::Intercept::BaseTest < BreezyTest
  def env
    {
      "rack.url_scheme" => "https",
      "SERVER_NAME" => "example.com",
      "SERVER_PORT" => "443",
      "PATH_INFO" => "/a/b.pdf",
      "QUERY_STRING" => "foo=bar"
    }
  end

  def app
    proc { |_app, _env| [] }
  end

  def test_render_url
    assert_equal "https://example.com/a/b?foo=bar", tested_class.new(app, env).send(:rendered_url)
  end

  def test_requested_url
    assert_equal "https://example.com/a/b.pdf?foo=bar", tested_class.new(app, env).send(:requested_url)
  end

  def test_base_url
    assert_equal "https://example.com", tested_class.new(app, env).send(:base_url)
  end

  def test_port_80
    assert_nil tested_class.new(app, env.merge("SERVER_PORT" => "80")).send(:port)
  end

  def test_port_443
    assert_nil tested_class.new(app, env.merge("SERVER_PORT" => "443")).send(:port)
  end

  def test_non_standard_port
    assert_equal ":1234", tested_class.new(app, env.merge("SERVER_PORT" => "1234")).send(:port)
  end

  def test_path
    assert_equal "xyz", tested_class.new(app, env.merge("PATH_INFO" => "xyz.pdf")).send(:path)
  end

  def test_nil_query_string
    assert_equal "", tested_class.new(app, env.merge("QUERY_STRING" => nil)).send(:query_string)
  end

  def test_blank_query_string
    assert_equal "", tested_class.new(app, env.merge("QUERY_STRING" => "")).send(:query_string)
  end

  def test_query_string
    assert_equal "?a=z", tested_class.new(app, env.merge("QUERY_STRING" => "a=z")).send(:query_string)
  end
end
