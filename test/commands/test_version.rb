require "test_helper"

module Test
  module Commands
    class TestVersion < Minitest::Test
      def test_version
        out, err = capture_io do
          Dry::CLI.new(Mytotp::Commands).call(arguments: ["version"])
        end
        assert_equal "", err
        assert_includes out, ::Mytotp::VERSION
      end

      def test_alias_v
        out = capture_io do
          Dry::CLI.new(Mytotp::Commands).call(arguments: ["v"])
        end
        assert_includes out[0], ::Mytotp::VERSION
      end

      def test_alias__v
        out = capture_io do
          Dry::CLI.new(Mytotp::Commands).call(arguments: ["-v"])
        end
        assert_includes out[0], ::Mytotp::VERSION
      end

      def test_alias__version
        out = capture_io do
          Dry::CLI.new(Mytotp::Commands).call(arguments: ["--version"])
        end
        assert_includes out[0], ::Mytotp::VERSION
      end
    end
  end
end
