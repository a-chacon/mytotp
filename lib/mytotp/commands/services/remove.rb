module Mytotp
  module Commands
    module Services
      ##
      # Class command for remove a service.
      # the service can be search by service's name and username for remove.
      class Remove < Dry::CLI::Command
        desc 'Remove a service.'
        argument :service, desc: 'Service name.'
        argument :username, desc: 'Username.'

        # Execute the command
        # @param service [String] service name to remove.
        # @param username [String] username in the service.
        def call(service: nil, username: nil, **)
          services = Mytotp::Models::Service.where(
            Sequel.ilike(:service, "%#{service}%")
          ).where(
            Sequel.ilike(:username, "%#{username}%")
          )
          case services.count
          when 0
            puts CLI::UI.fmt '{{yellow:No service found}}'
          when 1
            CLI::UI::Frame.open('We found one service!') do
              # ask to remove
              remove(services.first.id)
            end
          else
            # select one
            multiple_options(services)
          end
        end

        ##
        # Ask for which remove
        # @param services [Array[Mytotp::Models::Service]] Collection of services found by the input of the user.
        def multiple_options(services)
          CLI::UI::Frame.open('We found more than one!') do
            # puts services.map { |s| s.service + " " + s.username }
            id = CLI::UI::Prompt.ask('Which service do you want to remove?') do |handler|
              services.each do |s|
                handler.option("#{s.service} : #{s.username}") { |_selection| s.id }
              end
            end
            remove(id)
          end
        end

        ##
        # Remove a service by id
        # @param id [Integer] Unic ID of the service to remove.
        def remove(id)
          service_obj = Mytotp::Models::Service[id]
          answer = CLI::UI.ask('Are you sure?', options: %w[yes no])
          if answer == 'yes'
            service_obj.delete
            puts CLI::UI.fmt '{{red:Service successfull removed!}}'
          else
            puts CLI::UI.fmt '{{green:No service removed.}}'
          end
        end
      end
    end
  end
end
