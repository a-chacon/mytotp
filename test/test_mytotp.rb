# frozen_string_literal: true

require 'test_helper'

module Test
  class TestMytotp < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Mytotp::VERSION
    end

    def test_that_it_has_a_db_instance
      refute_nil ::Mytotp::DB
    end

    def test_that_it_has_a_app_name
      refute_nil ::Mytotp::APP_NAME
    end
  end
end
