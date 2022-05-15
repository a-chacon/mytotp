module Mytotp
  module Commands
    extend Dry::CLI::Registry

    # register clasess like commands
    register "version", Mytotp::Commands::Version, aliases: ["v", "-v", "--version"]
    register "generate", Mytotp::Commands::Generate, aliases: ["g"]
    register "service", Mytotp::Commands::Service
    register "service add", Mytotp::Commands::Services::Add
    register "service remove", Mytotp::Commands::Services::Remove
  end
end
