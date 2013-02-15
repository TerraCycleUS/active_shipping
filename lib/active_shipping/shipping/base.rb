require 'logger'
require 'forwardable'

module ActiveMerchant
  module Shipping
    module Base
      mattr_accessor :mode
      self.mode = :production
      
      def self.carrier(name)
        ActiveMerchant::Shipping::Carriers.all.find {|c| c.name.downcase == name.to_s.downcase} ||
          raise(NameError, "unknown carrier #{name}")
      end
      
      mattr_accessor :logger
      self.logger = Logger.new(STDERR)
      self.logger.level = Logger::INFO
    end
  end
end
