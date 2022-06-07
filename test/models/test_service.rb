require 'test_helper'

module Test
  module Models
    class TestService < Minitest::Test
      include SequelConfiguration

      def test_create
        service = ::Mytotp::Models::Service.new(service: 'github', username: 'andres.ch@pm.me', key: 'JBSWY3DPEHPK3PXP')
        assert service.save
        assert_equal(30, service.period)
        assert_equal(6, service.digits)
        assert_equal('GITHUB', service.service)
        assert_equal('ANDRES.CH@PM.ME', service.username)
      end
    end
  end
end
