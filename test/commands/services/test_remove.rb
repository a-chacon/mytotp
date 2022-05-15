require "test_helper"
require "stringio"

module Test
  module Commands
    module Services
      class TestRemove < Minitest::Test
        include SequelConfiguration

        def test_service_remove_command
          set_a_service
          out, err = capture_io do
            string_io = StringIO.new # New instance of StringIO
            string_io.puts "yes" # Stub user input of 0
            string_io.rewind         # Start form first stub
            $stdin = string_io       # Override Ruby's standard input
            Mytotp::Commands::Services::Remove.new.call(service: @service.service, username: @service.username)
            $stdin = STDIN           # Reset Ruby's standard input
          end
          # no error
          assert_equal "", err
          assert_includes out, "Service successfull removed"
          # include the default services
          assert_equal 1, Mytotp::Models::Service.all.count
        end
      end
    end
  end
end
