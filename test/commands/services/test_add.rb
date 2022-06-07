require 'test_helper'

module Test
  module Commands
    module Services
      class TestAdd < Minitest::Test
        include SequelConfiguration
        # TODO: tests for add command

        def test_service_add_command
          out, err = capture_io do
            Dry::CLI.new(Mytotp::Commands).call(arguments: ['service', 'add', 'heroku', 'test@test.cl',
                                                            'JBSWY3DPEHPK3PXP'])
            # Mytotp::Commands::Services::Add.new.call(service: "heroku", username: "test@test.cl",
            # key: "JBSWY3DPEHPK3PXP")
          end
          # no error
          assert_equal '', err
          # message
          assert_includes out, 'Correct saved!'
          # include the default services
          assert_equal 3, Mytotp::Models::Service.all.count
        end
      end
    end
  end
end
