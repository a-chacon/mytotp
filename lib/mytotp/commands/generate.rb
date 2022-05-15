module Mytotp
  module Commands
    ##
    # Class command for generate a totp token.
    # return IO
    class Generate < Dry::CLI::Command
      require "clipboard"

      desc "Generate a totp for a specific service."
      argument :service, require: true, desc: "Service name."
      argument :username, desc: "Username."
      option :mode, default: "once", values: %w[once continuos], desc: "The generator mode"

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

      private

      ##
      # Print message when is found one
      # Params: [Mytotp::Models::Service]
      # Returns: IO
      def found_one_message(services)
        puts CLI::UI.fmt "{{green:Service:}} #{services.first.service.capitalize}"
        puts CLI::UI.fmt "{{green:Username:}} #{services.first.username.capitalize}"
      end

      ##
      # Ask which service when we have more than one found.
      # Params: [Mytotp::Models::Service]
      # Returns: Mytotp::Models::Service
      def select_one(services)
        CLI::UI::Prompt.ask("Which service?") do |handler|
          services.each do |s|
            handler.option("#{s.service} : #{s.username}") { |_selection| s }
          end
        end
      end

      ##
      # Generate the complete message with the code
      # Params: Mytotp::Models::Service,String
      # Returns: IO
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
      # Params: nil
      # Returns: IO
      def clear_last_line
        # Clear the line
        print(CLI::UI::ANSI.previous_line + CLI::UI::ANSI.clear_to_end_of_line)
        # Force StdoutRouter to prefix
        print("#{CLI::UI::ANSI.previous_line} \n")
      end

      ##
      # Count seconds
      # Params: Mytotp::Models::Service, ROTP::TOTP
      # Returns: Integer
      def valid_for(service, totp)
        (service.period - (Time.now - Time.at(totp.verify(totp.now)))).round
      end

      ##
      # Print valid for
      # Params: Mytotp::Models::Service, ROTP::TOTP
      # Returns: IO
      def message_valid_for(service, totp)
        puts CLI::UI.fmt "{{green:Valid for:}} #{valid_for(service, totp)} seconds"
      end

      ##
      # Print the code
      # Params: String
      # Returns: IO
      def message_code(totp)
        if copy_to_clipboard(totp)
          puts CLI::UI.fmt "{{green:Current TOTP:}} #{totp} - {{green:Copy!}}"
        else
          puts CLI::UI.fmt "{{green:Current TOTP:}} #{totp} - {{red:It can't be copy.Do it manually.}}"
        end
      end

      ##
      # Copy code to clipboar
      # Params: String
      # Returns: String
      def copy_to_clipboard(code)
        Clipboard.copy(code)
        Clipboard.paste == code
      end
    end
  end
end
