module Mytotp
  module Commands
    ##
    # Class command for manage services.
    class Service < Dry::CLI::Command
      desc 'Manage your services. Whitout subcommands print services.'
      # call the command function
      def call(*)
        Mytotp::Models::Service.all.each do |s|
          puts CLI::UI.fmt "{{green:#{s.service.capitalize}}} - #{s.username.downcase}"
        end
      end
    end
  end
end
