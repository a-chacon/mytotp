module Mytotp
  module Commands
    ##
    # Class command for show the app version
    class Version < Dry::CLI::Command
      desc "Print #{::Mytotp::APP_NAME} version."

      # execute the command
      def call(*)
        puts VERSION
      end
    end
  end
end
