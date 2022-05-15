# frozen_string_literal: true

require_relative "lib/mytotp/version"

Gem::Specification.new do |spec|
  spec.name = "mytotp"
  spec.version = Mytotp::VERSION
  spec.authors = ["a-chacon"]
  spec.email = ["andres.ch@protonmail.com"]

  spec.summary = "Another totp cli"
  spec.description = "Totp cli tool for who loves the cli. With features that I don't found in another totp cli."
  spec.homepage = "https://github.com/a-chacon/mytotp"
  spec.license = "GPL-3.0"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/a-chacon/mytotp"
  spec.metadata["changelog_uri"] = "https://github.com/a-chacon/mytotp"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.bindir = "exe"
  spec.executables = ["mytotp"]
  spec.require_paths = ["lib"]

  spec.add_dependency "clipboard", "~> 1.3"
  spec.add_dependency "cli-ui", "~> 1.5"
  spec.add_dependency "dry-cli", "~> 0.7.0"
  spec.add_dependency "rotp", "~> 6.2"
  spec.add_dependency "sequel", "~> 5.56"
  spec.add_dependency "sqlite3", "~> 1.4", ">= 1.4.2"
  spec.add_dependency "zeitwerk", "~> 2.5", ">= 2.5.4"
end
