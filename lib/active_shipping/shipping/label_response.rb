module ActiveMerchant #:nodoc:
  module Shipping

  class LabelResponse < Response
    attr_reader :tracking_number, :image_data
    
    def initialize(success, message, params = {}, options = {})
      @tracking_number = options[:tracking_number]
      @image_data = options[:image_data]
      super
    end
  end

  end
end
