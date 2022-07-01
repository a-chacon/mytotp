# frozen_string_literal: true
require 'minitest/cc'
Minitest::Cc.start_coverage

ENV['MYTOTP_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'mytotp'
require 'minitest/autorun'
require 'minitest/rg'

module SequelConfiguration
  def setup
    Mytotp::Models::Service.create(service: 'github', username: 'andres.ch@pm.me', key: 'JBSWY3DPEHPK3PXP')
    Mytotp::Models::Service.create(service: 'rubygems', username: 'andres.ch@pm.me', key: 'JBSWY3DPEHPK3PXP')
  end

  def run(*args, &block)
    Mytotp::DB.transaction(rollback: :always, auto_savepoint: true) { super }
  end

  def set_a_service
    @service = Mytotp::Models::Service.first
  end

  def totp(service)
    @totp = ROTP::TOTP.new(service.key, interval: service.period, digits: service.digits)
  end
end
