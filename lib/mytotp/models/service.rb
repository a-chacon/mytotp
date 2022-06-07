module Mytotp
  # It's include the model created for save services
  module Models
    ##
    # Service model
    class Service < Sequel::Model
      # callback for apply upcase to service and username,
      # this is doing for make easy to search later
      def before_save
        self.service = service.upcase
        self.username = username.upcase
        super
      end
    end
  end
end
