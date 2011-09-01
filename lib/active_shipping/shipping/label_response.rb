module ActiveMerchant #:nodoc:
  module Shipping

    class LabelResponse < Response
      attr_reader :labels

      def initialize(success, message, params = {}, options = {})
        @labels = options[:labels]
        super
      end
    end

    class Label < Struct.new(:tracking_number, :image_data)
    end
  end
end
