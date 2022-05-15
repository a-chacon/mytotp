module Mytotp
  module Models
    ##
    # Service model
    class Service < Sequel::Model
      def before_save
        self.service = service.upcase
        self.username = username.upcase
        super
      end
    end
  end
end
