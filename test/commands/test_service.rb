require "test_helper"

module Test
  module Commands
    class TestService < Minitest::Test
      include SequelConfiguration

      def test_service_command
        out, err = capture_io do
          Dry::CLI.new(Mytotp::Commands).call(arguments: ["service"])
        end
        # no error
        assert_equal "", err
        # include the default services
        assert_includes out, "Github"
        assert_includes out, "Rubygems"
      end
    end
  end
end
