# -*- encoding: utf-8 -*-
require 'savon'
module ActiveMerchant
  module Shipping
    class SwissPost < Carrier
      @@name = "SwissPost"

      TEST_URL = 'https://www.mypostbusiness.ch/wsbc/barcode/v2_0'
      LIVE_URL = 'https://www.mypostbusiness.ch/wsbc/barcode/v2_0'

      def requirements
        [:login, :password, :franking_license]
      end


      def generate_label(origin, destination, packages, options = {})
        response = self.commit(origin, destination, packages)
        response = REXML::Document.new(response)
        success = response_success?(response)
        message = response_message(response)
        if success
          image_data = REXML::XPath.first(response, '//Label').text
          tracking_number = REXML::XPath.first(response, '//IdentCode').text
        end
        
        LabelResponse.new(success, message, {}, {
          :labels => [Label.new(
            tracking_number,
            image_data
          )]
        })

      end

      def response_success?(response)
        REXML::XPath.first(response, '//S:Fault').nil? ? true : false
      end

      def response_message(response)
        REXML::XPath.first(response, '//faultstring').text unless response_success?(response)
      end


      def commit(origin, destination, packages)
        client = Savon::Client.new do
          wsdl.document = File.dirname(__FILE__) + "/swiss_post_wsdl/barcode_v2_0.wsdl"
        end
        client.http.auth.basic @options[:login], @options[:password]
        response = client.request :typ, :generate_label do |soap|
          soap.namespaces['xmlns:typ'] = "https://www.mypostbusiness.ch/wsbc/barcode/v2_0/types"
          soap.body = request_body(origin, destination, packages)
        end
        response.http.body
      end


      def request_body(origin, destination, packages)
        <<-eos
        <typ:Language>en</typ:Language>
        <typ:Envelope>
        <typ:LabelDefinition>
        <typ:LabelLayout>A6</typ:LabelLayout>
        <typ:PrintAddresses>RecipientAndCustomer</typ:PrintAddresses>
        <typ:ImageFileType>GIF</typ:ImageFileType>
        <typ:ImageResolution>300</typ:ImageResolution>
        </typ:LabelDefinition>
        <typ:FileInfos>
        <typ:FrankingLicense>#{@options[:franking_license]}</typ:FrankingLicense>
        <typ:PpFranking>false</typ:PpFranking>
        <typ:Customer>
        <typ:CUS_Name1>#{origin.name}</typ:CUS_Name1>
        <typ:CUS_Name2>#{origin.company_name}</typ:CUS_Name2>
        <typ:CUS_Street>#{origin.address1}</typ:CUS_Street>
        <typ:CUS_POBox>#{origin.address2}</typ:CUS_POBox>
        <typ:CUS_ZIP>#{origin.postal_code}</typ:CUS_ZIP>
        <typ:CUS_City>#{origin.city}</typ:CUS_City>
        <typ:CUS_Country>#{origin.country_code}</typ:CUS_Country>
        <typ:CUS_DomicilePostOffice>#{origin.province}</typ:CUS_DomicilePostOffice>
        </typ:Customer>
        </typ:FileInfos>
        <typ:Data>
        <typ:Provider>
        <typ:Sending>
        <typ:Item>
        <typ:ItemID>2</typ:ItemID>
        <typ:Recipient>
        <typ:REC_Title>#{destination.title}</typ:REC_Title>
        <typ:REC_Name1>#{destination.name}</typ:REC_Name1>
        <typ:REC_Name2>#{destination.company_name}</typ:REC_Name2>
        <typ:REC_Street>#{destination.address1}</typ:REC_Street>
        <typ:REC_POBox>#{destination.address2}</typ:REC_POBox>
        <typ:REC_ZIP>#{destination.postal_code}</typ:REC_ZIP>
        <typ:REC_City>#{destination.city}</typ:REC_City>
        <typ:REC_Country>#{destination.country_code}</typ:REC_Country>
        <typ:REC_Phone>#{destination.phone}</typ:REC_Phone>
        <typ:REC_Mobile>#{destination.mobile}</typ:REC_Mobile>
        <typ:REC_EMail>#{destination.email}</typ:REC_EMail>
        <typ:REC_Data>
        <typ:REC_DAT>
        <typ:REC_DAT_Type></typ:REC_DAT_Type>
        <typ:REC_DAT_Value></typ:REC_DAT_Value>
        </typ:REC_DAT>
        </typ:REC_Data>
        </typ:Recipient>
        <typ:Attributes>
        <typ:ATT_PRZL>PRI</typ:ATT_PRZL>
        <typ:ATT_Amount>0</typ:ATT_Amount>
        <typ:ATT_FreeText></typ:ATT_FreeText>
        <typ:ATT_DeliveryDate>1970-01-01</typ:ATT_DeliveryDate>
        <typ:ATT_ParcelNo>0</typ:ATT_ParcelNo>
        <typ:ATT_ParcelTotal>0</typ:ATT_ParcelTotal>
        <typ:ATT_DeliveryPlace></typ:ATT_DeliveryPlace>
        <typ:ATT_ProClima>true</typ:ATT_ProClima>
        </typ:Attributes>
        </typ:Item>
        </typ:Sending>
        </typ:Provider>
        </typ:Data>
        </typ:Envelope>
        eos
      end

    end


  end
end
