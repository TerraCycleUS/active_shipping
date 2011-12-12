module ActiveMerchant
  module Shipping

    class Dhl < Carrier
      self.retry_safe = true

      cattr_reader :name
      @@name = "Dhl"

      TEST_URL = 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
      LIVE_URL = 'https://xmlpi-ea.dhl.com/XMLShippingServlet'

      PackageTypes = {
        "EE" => "DHL Express Envelope",
        "OD" => "Other DHL Packaging",
        "CP" => "Custom Packaging",
        "DC" => "Document",
        "DM" => "Domestic",
        "ED" => "Express Document",
        "FR" => "Freight",
        "BD" => "Jumbo Document",
        "BP" => "Jumbo Parcel",
        "JD" => "Jumbo Junior Document",
        "JP" => "Jumbo Junior Parcel",
        "PA" => "Parcel",
        "DF" => "DHL Flyer"
      }
      PaymentTypes = {
        'shipper' => 'S',
        'receiver' => 'R',
        'third_party' => 'T'
      }

      GlobalProductCodes = {

        "0"	=> "LOGISTICS SERVICES",
        "1"	=> "CUSTOMS SERVICES",
        "2"	=> "EASY SHOP",
        "3"	=> "EASY SHOP",
        "4"	=> "JETLINE",
        "5"	=> "SPRINTLINE",
        "6"	=> "SECURELINE",
        "7"	=> "EXPRESS EASY",
        "8"	=> "EXPRESS EASY",
        "9"	=> "EUROPACK",
        "A"	=> "AUTO REVERSALS",
        "B"	=> "BREAK BULK EXPRESS",
        "C"	=> "MEDICAL EXPRESS",
        "D"	=> "EXPRESS WORLDWIDE",
        "E"	=> "EXPRESS 9:00",
        "F"	=> "FREIGHT WORLDWIDE",
        "G"	=> "DOMESTIC ECONOMY SELECT",
        "H"	=> "ECONOMY SELECT",
        "I"	=> "BREAK BULK ECONOMY",
        "J"	=> "JUMBO BOX",
        "K"	=> "EXPRESS 9:00",
        "L"	=> "EXPRESS 10:30",
        "M"	=> "EXPRESS 10:30",
        "N"	=> "DOMESTIC EXPRESS",
        "O"	=> "OTHERS",
        "P"	=> "EXPRESS WORLDWIDE",
        "Q"	=> "MEDICAL EXPRESS",
        "R"	=> "GLOBALMAIL BUSINESS",
        "S"	=> "SAME DAY",
        "T"	=> "EXPRESS 12:00",
        "U"	=> "EXPRESS WORLDWIDE",
        "V"	=> "EUROPACK",
        "W"	=> "ECONOMY SELECT",
        "X"	=> "EXPRESS ENVELOPE",
        "Y"	=> "EXPRESS 12:00",
        "Z"	=> "Destination Charges"


      }

      DHL_Currency_Codes = {
        "AD"	=>     "EUR",
        "AE"	=>     "AED",
        "AF"	=>     "AFN",
        "AG"	=>     "XCD",
        "AI"	=>     "XCD",
        "AL"	=>     "EUR",
        "AM"	=>     "AMD",
        "AN"	=>     "ANG",
        "AO"	=>     "AOA",
        "AR"	=>     "ARS",
        "AS"	=>     "USD",
        "AT"	=>     "EUR",
        "AU"	=>     "AUD",
        "AW"	=>     "AWG",
        "AZ"	=>     "AZM",
        "BA"	=>     "BAM",
        "BB"	=>     "BBD",
        "BD"	=>     "BDT",
        "BE"	=>     "EUR",
        "BF"	=>     "XOF",
        "BG"	=>     "BGN",
        "BH"	=>     "BHD",
        "BI"	=>     "BIF",
        "BJ"	=>     "XOF",
        "BM"	=>     "BMD",
        "BN"	=>     "BND",
        "BO"	=>     "BOB",
        "BR"	=>     "BRL",
        "BS"	=>     "BSD",
        "BT"	=>     "BTN",
        "BW"	=>     "BWP",
        "BY"	=>     "BYR",
        "BZ"	=>     "BZD",
        "CA"	=>     "CAD",
        "CD"	=>     "CDF",
        "CF"	=>     "XAF",
        "CG"	=>     "XAF",
        "CH"	=>     "CHF",
        "CI"	=>     "XOF",
        "CK"	=>     "NZD",
        "CL"	=>     "CLP",
        "CM"	=>     "XAF",
        "CN"	=>     "CNY",
        "CO"	=>     "COP",
        "CR"	=>     "CRC",
        "CU"	=>     "CUP",
        "CV"	=>     "CVE",
        "CY"	=>     "EUR",
        "CZ"	=>     "CZK",
        "DE"	=>     "EUR",
        "DJ"	=>     "DJF",
        "DK"	=>     "DKK",
        "DM"	=>     "XCD",
        "DO"	=>     "DOP",
        "DZ"	=>     "DZD",
        "EC"	=>     "USD",
        "EE"	=>     "EEK",
        "EG"	=>     "EGP",
        "ER"	=>     "ERN",
        "ES"	=>     "EUR",
        "ET"	=>     "ETB",
        "FI"	=>     "EUR",
        "FJ"	=>     "FJD",
        "FK"	=>     "FKP",
        "FM"	=>     "USD",
        "FO"	=>     "DKK",
        "FR"	=>     "EUR",
        "GA"	=>     "XAF",
        "GB"	=>     "GBP",
        "GD"	=>     "XCD",
        "GE"	=>     "GEL",
        "GF"	=>     "EUR",
        "GG"	=>     "GBP",
        "GH"	=>     "GHS",
        "GI"	=>     "GIP",
        "GL"	=>     "DKK",
        "GM"	=>     "GMD",
        "GN"	=>     "GNF",
        "GP"	=>     "EUR",
        "GQ"	=>     "XAF",
        "GR"	=>     "EUR",
        "GT"	=>     "GTQ",
        "GU"	=>     "USD",
        "GW"	=>     "GWP",
        "GY"	=>     "GYD",
        "HK"	=>     "HKD",
        "HN"	=>     "HNL",
        "HR"	=>     "HRK",
        "HT"	=>     "HTG",
        "HU"	=>     "HUF",
        "IC"	=>     "EUR",
        "ID"	=>     "IDR",
        "IE"	=>     "EUR",
        "IL"	=>     "ILS",
        "IN"	=>     "INR",
        "IQ"	=>     "IQD",
        "IR"	=>     "IRR",
        "IS"	=>     "ISK",
        "IT"	=>     "EUR",
        "JE"	=>     "GBP",
        "JM"	=>     "JMD",
        "JO"	=>     "JOD",
        "JP"	=>     "JPY",
        "KE"	=>     "KES",
        "KG"	=>     "KGS",
        "KH"	=>     "KHR",
        "KI"	=>     "AUD",
        "KM"	=>     "KMF",
        "KN"	=>     "XCD",
        "KP"	=>     "KPW",
        "KR"	=>     "KRW",
        "KV"	=>     "EUR",
        "KW"	=>     "KWD",
        "KY"	=>     "KYD",
        "KZ"	=>     "KZT",
        "LA"	=>     "LAK",
        "LB"	=>     "USD",
        "LC"	=>     "XCD",
        "LI"	=>     "CHF",
        "LK"	=>     "LKR",
        "LR"	=>     "LRD",
        "LS"	=>     "LSL",
        "LT"	=>     "LTL",
        "LU"	=>     "EUR",
        "LV"	=>     "LVL",
        "LY"	=>     "LYD",
        "MA"	=>     "MAD",
        "MC"	=>     "EUR",
        "MD"	=>     "MDL",
        "ME"	=>     "EUR",
        "MG"	=>     "MGA",
        "MH"	=>     "USD",
        "MK"	=>     "MKD",
        "ML"	=>     "XOF",
        "MM"	=>     "USD",
        "MN"	=>     "MNT",
        "MO"	=>     "MOP",
        "MP"	=>     "USD",
        "MQ"	=>     "EUR",
        "MR"	=>     "MRO",
        "MS"	=>     "XCD",
        "MT"	=>     "EUR",
        "MU"	=>     "MUR",
        "MV"	=>     "MVR",
        "MW"	=>     "MWK",
        "MX"	=>     "MXN",
        "MY"	=>     "MYR",
        "MZ"	=>     "MZN",
        "NA"	=>     "ZAR",
        "NC"	=>     "XPF",
        "NE"	=>     "XOF",
        "NG"	=>     "NGN",
        "NI"	=>     "NIO",
        "NL"	=>     "EUR",
        "NO"	=>     "NOK",
        "NP"	=>     "NPR",
        "NR"	=>     "AUD",
        "NU"	=>     "NZD",
        "NZ"	=>     "NZD",
        "OM"	=>     "OMR",
        "PA"	=>     "PAB",
        "PE"	=>     "PEN",
        "PF"	=>     "XPF",
        "PG"	=>     "PGK",
        "PH"	=>     "PHP",
        "PK"	=>     "PKR",
        "PL"	=>     "PLN",
        "PR"	=>     "USD",
        "PT"	=>     "EUR",
        "PW"	=>     "USD",
        "PY"	=>     "PYG",
        "QA"	=>     "QAR",
        "RE"	=>     "EUR",
        "RO"	=>     "RON",
        "RS"	=>     "RSD",
        "RU"	=>     "RUB",
        "RW"	=>     "RWF",
        "SA"	=>     "SAR",
        "SB"	=>     "SBD",
        "SC"	=>     "SCR",
        "SD"	=>     "SDG",
        "SE"	=>     "SEK",
        "SG"	=>     "SGD",
        "SI"	=>     "EUR",
        "SK"	=>     "EUR",
        "SL"	=>     "SLL",
        "SM"	=>     "EUR",
        "SN"	=>     "XOF",
        "SO"	=>     "SOS",
        "SR"	=>     "SRD",
        "ST"	=>     "STD",
        "SV"	=>     "USD",
        "SY"	=>     "SYP",
        "SZ"	=>     "SZL",
        "TC"	=>     "USD",
        "TD"	=>     "XAF",
        "TG"	=>     "XOF",
        "TH"	=>     "THB",
        "TJ"	=>     "TJS",
        "TL"	=>     "USD",
        "TN"	=>     "TND",
        "TO"	=>     "TOP",
        "TR"	=>     "TRY",
        "TT"	=>     "TTD",
        "TV"	=>     "AUD",
        "TW"	=>     "TWD",
        "TZ"	=>     "TZS",
        "UA"	=>     "UAH",
        "UG"	=>     "UGX",
        "US"	=>     "USD",
        "UY"	=>     "UYU",
        "UZ"	=>     "UZS",
        "VC"	=>     "XCD",
        "VE"	=>     "VEF",
        "VG"	=>     "USD",
        "VI"	=>     "USD",
        "VN"	=>     "VND",
        "VU"	=>     "VUV",
        "WS"	=>     "WST",
        "XB"	=>     "EUR",
        "XC"	=>     "EUR",
        "XE"	=>     "ANG",
        "XM"	=>     "EUR",
        "XN"	=>     "XCD",
        "XS"	=>     "SIS",
        "XY"	=>     "ANG",
        "YE"	=>     "YER",
        "YT"	=>     "EUR",
        "ZA"	=>     "ZAR",
        "ZM"	=>     "ZMK",
        "ZW"	=>     "ZWD"
      }

      DoorTo = {
        'DD' => "Door to Door",
        'DA' => "Door to Airport",
        'AA' => 'Door to Dor non-compliant',
        'AA' => 'Door to Dor non-compliant'
      }

      def requirements
        [:login, :password, :account_number, :test]
      end


      def generate_label(origin, destination, packages, options = {})
        options = @options.update(options)
        packages = Array(packages)
        label_request = build_label_request(origin, destination, packages, options)

        response = commit(save_request(label_request), options[:test])
        result =  parse_label_response(response, options)
        result
      end

      def parse_label_response(response, options ={})

        xml = REXML::Document.new(response).root
        success = response_success?(xml)
        message = response_message(response) unless success
        DhlLabelResponse.new(success, message, Hash.from_xml(response))
      end

      def response_success?(document)
        if response_status_node(document)
          %w{Success}.include? response_status_node(document).get_text('ActionNote').to_s
        else
          false
        end
      end

      def response_message(document)
        res = Hash.from_xml(document)
        res = res["ShipmentValidateErrorResponse"]
        "#{res['Response']['Status']['Condition']['ConditionCode']} - #{res['Response']['Status']['Condition']['ConditionData']}"
      end

      def response_status_node(document)
        document.elements['/*/Note/']
      end

      # def parse_label_response(response, options)
      #   return true
      # end

      protected

      def build_instruct
        '<?xml version="1.0" encoding="UTF-8"?>
        <req:ShipmentValidateRequestEA xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com
        ship-val-req_EA.xsd">'
      end

      def build_request_service_header
        xml_request = Builder::XmlMarkup.new
        xml_request.Request do |r|
          r.ServiceHeader do |servhead|
            servhead.SiteID @options[:login]
            servhead.Password @options[:password]
          end
        end
        xml_request.NewShipper 'N'
        xml_request.LanguageCode 'en'
        xml_request.PiecesEnabled 'Y'

        xml_request.target!
      end

      def build_billing(options)
        xml_request = Builder::XmlMarkup.new
        xml_request.Billing do |b|
          b.ShipperAccountNumber @options[:account_number]
          b.ShippingPaymentType  options[:payment_type]
          b.BillingAccountNumber @options[:account_number]
        end
        xml_request.target!
      end

      def build_consignee(destination)
        xml_request = Builder::XmlMarkup.new
        xml_request.Consignee do |c|
          c = build_location(c, destination)
        end
        xml_request.target!
      end

      def build_location(target, location, options = {})
        target.CompanyName location.company_name
        target.RegisteredAccount options[:shipper_id] unless options[:shipper_id].nil?
        target.AddressLine location.address1
        target.AddressLine location.address2 unless location.address2.nil?
        target.City location.city
        target.Division location.state
        target.PostalCode location.postal_code
        target.CountryCode location.country_code
        target.CountryName location.country
        target.Contact do |contact|
          contact.PersonName location.name
          contact.PhoneNumber location.phone
        end
        target
      end

      def build_ship_location(target, location, options = {})
        target.CompanyName location.company_name
        target.RegisteredAccount options[:shipper_id] unless options[:shipper_id].nil?
        target.AddressLine location.address1
        target.AddressLine location.address2 unless location.address2.nil?
        target.City location.city
        target.Division location.state
        target.PostalCode location.postal_code
        target.CountryCode location.country_code
        target.CountryName location.country
        target.Contact do |sc|
          sc.PersonName location.name
          sc.PhoneNumber location.phone
        end
        target
      end

      def build_shipper(origin, options)
        xml_request = Builder::XmlMarkup.new
        xml_request.Shipper do |shipper|
          shipper.ShipperID options[:shipper_id]
          shipper = build_ship_location(shipper, origin, options)
        end
        xml_request.target!
      end

      def build_commodity
        xml_request = Builder::XmlMarkup.new
        xml_request.Commodity do |com|
          com.CommodityCode '1'
          com.CommodityName 'String'
        end
        xml_request.target!
      end

      def build_shipment_details(packages, origin, options)
        imperial = ['US','LR','MM'].include?(origin.country_code(:alpha2))
        xml_request = Builder::XmlMarkup.new
        xml_request.ShipmentDetails do |sd|
          sd.NumberOfPieces packages.size
          sd.CurrencyCode DHL_Currency_Codes[origin.country_code]
          sd.Pieces do |pieces|
            packages.each do |package|
              pieces.Piece do |piece|
                piece.PieceID packages.index(package)
                piece.PackageType options[:package_type]
                piece.Weight package.weight.to_f.round/1000.0
                piece.Depth  (imperial ? package.inches(:length).to_i : package.cm(:length).to_i)
                piece.Width  (imperial ? package.inches(:width).to_i : package.cm(:width).to_i)
                piece.Height (imperial ? package.inches(:height).to_i : package.cm(:height).to_i)
              end
            end
          end
          sd.PackageType options[:package_type]
          sd.Weight packages.map{|package| package.weight}.inject(0){|sum, i| sum + i}
          sd.DimensionUnit  imperial ? 'I' : 'C'
          sd.WeightUnit imperial ? 'L' : 'K'
          sd.GlobalProductCode options[:global_product_code]
          sd.LocalProductCode options[:local_product_code]
          sd.DoorTo options[:door_to]
          sd.Date Time.now.strftime("%Y-%m-%d")
          sd.Contents options[:content]
        end

        xml_request.target!
      end

      def build_label_request(origin, destination, packages, options)
        request = build_instruct
        request += build_request_service_header
        request += build_billing(options)
        request += build_consignee(destination)
        request += build_shipment_details(packages, origin, options)
        request += build_shipper(origin, options)
        request += '</req:ShipmentValidateRequestEA>'
        request
      end



      def commit(request, test = false)
        ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))
      end

    end
  end




end
