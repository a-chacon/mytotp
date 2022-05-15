module Mytotp
  module Commands
    ##
    # Class command for show the app version
    # return String
    class Version < Dry::CLI::Command
      desc "Print #{::Mytotp::APP_NAME} version."
      def call(*)
        puts VERSION
      end
    end
  end
end
