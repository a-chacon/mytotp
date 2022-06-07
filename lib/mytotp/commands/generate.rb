module Mytotp
  module Commands
    ##
    # Class command for generate a totp token.
    class Generate < Dry::CLI::Command
      require "clipboard"

      desc "Generate a totp for a specific service."
      argument :service, require: true, desc: "Service name."
      argument :username, desc: "Username."
      option :mode, default: "once", values: %w[once continuos], desc: "The generator mode"

      # call the command function
      # @param service [String] Service's name to generate the totp code.
      # @param username [String] Service's username to generate the totp code.
      def call(service: nil, username: nil, **options)
        # find services
        services = Mytotp::Models::Service.where(Sequel.ilike(:service, "%#{service}%"))
                                          .where(Sequel.ilike(:username, "%#{username}%"))
        # select one service
        service =
          if services.count == 1
            found_one_message(services)
            services.first
          elsif services.count > 1
            select_one(services)
          else
            select_one(Mytotp::Models::Service.all)
          end
        # generate the complete message with the code
        generate_code(service, options.fetch(:mode))
      end

      ##
      # Print message when is found one
      # @param services [Collection[Mytotp::Models::Service]] Collection of services.
      def found_one_message(services)
        puts CLI::UI.fmt "{{green:Service:}} #{services.first.service.capitalize}"
        puts CLI::UI.fmt "{{green:Username:}} #{services.first.username.capitalize}"
      end

      ##
      # Ask which service when we have more than one found.
      # @param services [Collection[Mytotp::Models::Service]] Collection of services.
      # @return [Mytotp::Models::Service] selected service
      def select_one(services)
        CLI::UI::Prompt.ask("Which service?") do |handler|
          services.each do |s|
            handler.option("#{s.service} : #{s.username}") { |_selection| s }
          end
        end
      end

      ##
      # Generate the complete message with the code
      # @param service [Mytotp::Models::Service] Selected service for generate the totp code
      # @param mode [String] Mode for generate the code, it can be 'continuos' or by default 'once'
      def generate_code(service, mode)
        totp = ROTP::TOTP.new(service.key, interval: service.period, digits: service.digits)
        if mode == "continuos"
          # infinit loop
          loop do
            actual_code = totp.now
            message_code(actual_code)
            loop do
              message_valid_for(service, totp)
              sleep 1
              clear_last_line
              break unless totp.verify(actual_code)
            end
            clear_last_line
          end
        else
          # print once
          message_code(totp.now)
          message_valid_for(service, totp)
        end
      end

      ##
      # clear last line in the console
      def clear_last_line
        # Clear the line
        print(CLI::UI::ANSI.previous_line + CLI::UI::ANSI.clear_to_end_of_line)
        # Force StdoutRouter to prefix
        print("#{CLI::UI::ANSI.previous_line} \n")
      end

      ##
      # Count seconds
      # @param service [Mytotp::Models::Service] Service to validate.
      # @param totp [ROTP::TOTP] totp object generated with the service token.
      # @return [Integer] seconds
      def valid_for(service, totp)
        (service.period - (Time.now - Time.at(totp.verify(totp.now)))).round
      end

      ##
      # Print valid for
      # @param service [Mytotp::Models::Service] Service to validate.
      # @param totp [ROTP::TOTP] totp object generated with the service token.
      def message_valid_for(service, totp)
        puts CLI::UI.fmt "{{green:Valid for:}} #{valid_for(service, totp)} seconds"
      end

      ##
      # Print the code
      # @param totp [String] totp code generate for print.
      def message_code(totp)
        if copy_to_clipboard(totp)
          puts CLI::UI.fmt "{{green:Current TOTP:}} #{totp} - {{green:Copy!}}"
        else
          puts CLI::UI.fmt "{{green:Current TOTP:}} #{totp} - {{red:It can't be copy.Do it manually.}}"
        end
      end

      ##
      # Copy code to clipboar
      # @param code [String] Code to be copy on the clipboard.
      # @return [Boolean] True or false depending if it was copy to clipboard or not.
      def copy_to_clipboard(code)
        Clipboard.copy(code)
        Clipboard.paste == code
      end
    end
  end
end
