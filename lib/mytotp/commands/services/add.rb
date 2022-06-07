module Mytotp
  module Commands
    # services subcommands module
    # it's group the service subcommands
    module Services
      ##
      # Class command for add a new service.
      class Add < Dry::CLI::Command
        desc 'Add a new service.'

        argument :service, desc: 'Service name.'
        argument :username, desc: "Account's username"
        argument :key, desc: 'Secret key'

        # execute the command
        # @param service [String] service name to add
        # @param username [String] username used in the service
        # @param key [String] totp key shared for generate the otp codes
        def call(service: nil, username: nil, key: nil, **)
          service_obj = Mytotp::Models::Service.new(service: service, username: username,
                                                    key: key)
          service_obj = ask_for_incomplete(service_obj)
          service_obj.save
          puts CLI::UI.fmt '{{green:Correct saved!}}'
        rescue StandardError => e
          print(e.to_s)
          puts CLI::UI.fmt '{{red:Something is not fine, try again!}}'
        end

        ##
        # Ask incomplete information for a service_obj
        # @param service_obj [Mytotp::Models::Service] the service object created with the arguments provided
        # @return [Mytotp::Models::Service] the service object modify by the questions to the user
        def ask_for_incomplete(service_obj)
          # Check service if was input by argument or interactive ask
          if service_obj.service.nil?
            service_obj.service = CLI::UI.ask(
              'Which service do you want to add?', allow_empty: false
            )
          end
          # Check service if was input by argument or interactive ask
          service_obj.username = CLI::UI.ask('Username?', allow_empty: false) if service_obj.username.nil?
          # Check service if was input by argument or interactive ask
          service_obj.key = CLI::UI.ask('Key?', allow_empty: false) if service_obj.key.nil?
          service_obj
        end
      end
    end
  end
end
