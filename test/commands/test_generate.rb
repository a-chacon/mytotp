require 'test_helper'

module Test
  module Commands
    class TestGenerate < Minitest::Test
      include SequelConfiguration
      # TODO: tests for generate command
      def test_generate_command
        set_a_service
        totp(@service)
        out, err = capture_io do
          Mytotp::Commands::Generate.new.call(service: @service.service, username: @service.username, mode: 'once')
        end
        # no error
        assert_equal '', err
        # test the message includes
        assert_includes out, @totp.now
        assert_includes out, @service.service.capitalize
        assert_includes out, @service.username.capitalize
      end
    end
  end
end
