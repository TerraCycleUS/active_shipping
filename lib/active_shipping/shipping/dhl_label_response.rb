module ActiveMerchant #:nodoc:
  module Shipping

    class DhlLabelResponse < Response
      attr_reader :product_name, :product_content_code, :unit_id, :shipment_date, :service_area_code, :shipper_company_name, :shipper_address_1,
      :shipper_address_2, :shipper_city, :shipper_division, :shipper_postal_code,
      :shipper_country, :shipper_contact_name, :shipper_contact_phone, :origin_service_area,
      :service_area_code, :receiver_company_name, :receiver_address_1, :receiver_address_2,
      :receiver_city, :receiver_division, :receiver_postal_code, :receiver_country,
      :receiver_contact_name, :receiver_contact_phone, :outbound_sort_code, :destination_facility_code,
      :inbound_sort_code, :message_reference, :account_number, :weight, :weight_unit,
      :awb_barcode, :origin_destination_barcode, :dhl_routing_barcode, :airway_bill_number,
      :dhl_routing_code, :dhl_routing_data_id, :data_identifier, :license_plate
      def initialize(success, message, res = {}, options = {})

        res = res["ShipmentValidateResponse"]
        @product_name = res['ProductShortName']
        @product_content_code = res['ProductContentCode']
        @unit_id = res['CustomerID']
        @shipment_date = res['ShipmentDate']
        @service_area_code = res['OriginServiceArea']['ServiceAreaCode']
        @shipper_company_name = res['Shipper']['CompanyName']
        if res['Shipper']['AddressLine'].respond_to?(:each)
          @shipper_address_1 = res['Shipper']['AddressLine'].first
          @shipper_address_2 = res['Shipper']['AddressLine'].last
        else
          @shipper_address_1 = res['Shipper']['AddressLine']
        end
        @shipper_address_1 = res['Shipper']['AddressLine']
        @shipper_city = res['Shipper']['City']
        @shipper_division = res['Shipper']['Division'] || ''
        @shipper_postal_code = res['Shipper']['PostalCode']
        @shipper_country = res['Shipper']['CountryName']
        @shipper_contact_name = res['Shipper']['Contact']['PersonName']
        @shipper_contact_phone = res['Shipper']['Contact']['PhoneNumber']
        @origin_service_area = res['DestinationServiceArea']['ServiceAreaCode']
        @receiver_company_name = res['Consignee']['CompanyName']
        if res['Consignee']['AddressLine'].respond_to?(:each)
          @receiver_address_1 = res['Consignee']['AddressLine'].first
          @receiver_address_2 = res['Consignee']['AddressLine'].last
        else
          @receiver_address_1 = res['Consignee']['AddressLine']
        end
        @receiver_city = res['Consignee']['City']
        @receiver_division = res['Consignee']['Division']
        @receiver_postal_code = res['Consignee']['PostalCode']
        @receiver_country = res['Consignee']['CountryName']
        @receiver_contact_name = res['Consignee']['Contact']['PersonName']
        @receiver_contact_phone = res['Consignee']['Contact']['PhoneNumber']
        @outbound_sort_code = res['OriginServiceArea']['OutboundSortCode']  || ''
        @destination_facility_code = res['DestinationServiceArea']['FacilityCode']
        @inbound_sort_code = res['DestinationServiceArea']['InboundSortCode'] || ''
        @message_reference = res['Response']['ServiceHeader']['MessageReference']
        @account_number = res['Billing']['ShipperAccountNumber']
        @weight = res['ChargeableWeight']
        @weight_unit = res['WeightUnit']
        @awb_barcode = res['Barcodes']['AWBBarCode']
        @origin_destination_barcode = res['Barcodes']['OriginDestnBarcode']
        @dhl_routing_barcode = res['Barcodes']['DHLRoutingBarCode']
        @raw_airway_bill_number = res['AirwayBillNumber']
        @dhl_routing_code = res['DHLRoutingCode']
        @dhl_routing_data_id = res['DHLRoutingDataId']
        @data_identifier = res['Pieces']['Piece']['DataIdentifier']
        @raw_license_plate = res['Pieces']['Piece']['LicensePlate']
      end
      
      def airway_bill_number
        "#{@raw_airway_bill_number[0..1]} #{@raw_airway_bill_number[2..5]} #{@raw_airway_bill_number[6..10]}"
      end
      
      #Transforms license plate number into the format needed for labels
      #It's basically the first 5 digits
      #Then multiples of 4 grouped from the end of the string with the remainder
      #sitting between the first 5 digit chunk and the last chunk of 4 digit groupings
      #yeah it's weird but that's how dhl rolls
      def license_plate
        raw = @raw_license_plate
        iac = raw[0..4]
        raw = @raw_license_plate[5..raw.length]
        res= []
        (raw.length / 4).times do
          slice = raw.slice((raw.length - 4), raw.length)
          res <<  slice
          raw = raw.gsub(slice, '')
        end
        remainder = raw.gsub(res.reverse.join, '')
        res = [iac, remainder, res.reverse].flatten.join(" ")
        res
      end
      
      def reference_data
        "YYYY-MM-DD"
      end

      def service_features_code
        "C"
      end

      def eei
        "NOEEI 30.37(a)"
      end

      def piece
        "1/1"
      end
      
    end    
  end
end
