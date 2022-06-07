# require_relative "mytotp/version"
require "dry/cli"
require "sequel"
require "zeitwerk"
require "cli/ui"
require "rotp"
# code loader
Zeitwerk::Loader.eager_load_all
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

# Main module of the app,
# its contains the global variables and configurations
# @author a-chacon
module Mytotp
  # app name
  APP_NAME = "Mytotp".freeze
  # cli configuration
  CLI::UI.frame_style = :bracket
  CLI::UI::StdoutRouter.enable

  if ENV.fetch("MYTOTP_ENV", nil) == "test"
    # db connection, in memmory only
    DB = Sequel.sqlite
  else
    # create config dir if not exist
    Dir.mkdir "#{Dir.home}/.mytotp" unless Dir.exist? "#{Dir.home}/.mytotp"
    # db connection
    DB = Sequel.connect("sqlite://#{Dir.home}/.mytotp/mytotp.db")
  end
  # create table if not exists
  unless DB.table_exists?(:services)
    DB.create_table :services do
      primary_key :id
      varchar :service, empty: false
      varchar :username, empty: false
      varchar :key, empty: false
      integer :digits, default: 6
      integer :period, default: 30
    end
  end
end
