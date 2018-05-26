# frozen_string_literal: true

require 'minitest/autorun'
require 'rails5_xhr_update'

class XHRToRails5Test < MiniTest::Test
  def test_get_with_empty_params
    source = convert <<~RB
      def get
        xhr :get, images_path, {}
      end
    RB
    assert_includes(source, 'get images_path, xhr: true')
  end

  def test_get_with_no_params
    source = convert <<~RB
      def get
        xhr :get, images_path
      end
    RB
    assert_includes(source, 'get images_path, xhr: true')
  end

  def test_get_with_single_param
    source = convert <<~RB
      def get
        xhr :get, images_path, id: 1
      end
    RB
    assert_includes(source, 'get images_path, params: { id: 1 }, xhr: true')
  end

  private

  def convert(string)
    buffer = Parser::Source::Buffer.new('simple.rb')
    buffer.raw_source = string
    Rails5XHRUpdate::XHRToRails5.new.rewrite(
      buffer, Parser::CurrentRuby.new.parse(buffer)
    )
  end
end
