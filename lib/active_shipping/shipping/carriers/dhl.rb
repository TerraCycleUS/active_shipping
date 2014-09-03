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

      DHL_Country_Codes = {
        'AD' => "Andorra",
        'AE' => "United Arab Emirates",
        'AF' => "Afghanistan",
        'AG' => "Antigua",
        'AI' => "Anguilla",
        'AL' => "Albania",
        'AM' => "Armenia",
        'AN' => "Netherlands Antilles",
        'AO' => "Angola",
        'AR' => "Argentina",
        'AS' => "American Samoa",
        'AT' => "Austria",
        'AU' => "Australia",
        'AW' => "Aruba",
        'AZ' => "Azerbaijan",
        'BA' => "Bosnia and Herzegovina",
        'BB' => "Barbados",
        'BD' => "Bangladesh",
        'BE' => "Belgium",
        'BF' => "Burkina Faso",
        'BG' => "Bulgaria",
        'BH' => "Bahrain",
        'BI' => "Burundi",
        'BJ' => "Benin",
        'BM' => "Bermuda",
        'BN' => "Brunei",
        'BO' => "Bolivia",
        'BR' => "Brazil",
        'BS' => "Bahamas",
        'BT' => "Bhutan",
        'BW' => "Botswana",
        'BY' => "Belarus",
        'BZ' => "Belize",
        'CA' => "Canada",
        'CD' => "Congo",
        'CF' => "Central African Republic",
        'CG' => "Congo",
        'CH' => "Switzerland",
        'CI' => "Cote d'Ivoire",
        'CK' => "Cook Islands",
        'CL' => "Chile",
        'CM' => "Cameroon",
        'CN' => "China",
        'CO' => "Colombia",
        'CR' => "Costa Rica",
        'CU' => "Cuba",
        'CV' => "Cape Verde",
        'CY' => "Cyprus",
        'CZ' => "Czech Republic",
        'DE' => "Germany",
        'DJ' => "Djibouti",
        'DK' => "Denmark",
        'DM' => "Dominica",
        'DO' => "Dominican Rep.",
        'DZ' => "Algeria",
        'EC' => "Ecuador",
        'EE' => "Estonia",
        'EG' => "Egypt",
        'ER' => "Eritrea",
        'ES' => "Spain",
        'ET' => "Ethiopia",
        'FI' => "Finland",
        'FJ' => "Fiji",
        'FK' => "Falkland Islands",
        'FM' => "MICRONESIA",
        'FO' => "Faroe Islands",
        'FR' => "France",
        'GA' => "Gabon",
        'GB' => "United Kingdom",
        'GD' => "Grenada",
        'GE' => "Georgia",
        'GF' => "French Guyana",
        'GG' => "Guernsey",
        'GH' => "Ghana",
        'GI' => "Gibraltar",
        'GL' => "Greenland",
        'GM' => "Gambia",
        'GN' => "Guinea Republic",
        'GP' => "Guadeloupe",
        'GQ' => "Guinea-Equatorial",
        'GR' => "Greece",
        'GT' => "Guatemala",
        'GU' => "Guam",
        'GW' => "Guinea-Bissau",
        'GY' => "Guyana (British)",
        'HK' => "Hong Kong",
        'HN' => "Honduras",
        'HR' => "Croatia",
        'HT' => "Haiti",
        'HU' => "Hungary",
        'IC' => "Canary Islands",
        'ID' => "Indonesia",
        'IE' => "Ireland",
        'IL' => "Israel",
        'IN' => "India",
        'IQ' => "Iraq",
        'IR' => "Iran (Islamic Republic of)",
        'IS' => "Iceland",
        'IT' => "Italy",
        'JE' => "Jersey",
        'JM' => "Jamaica",
        'JO' => "Jordan",
        'JP' => "Japan",
        'KE' => "Kenya",
        'KG' => "Kyrgyzstan",
        'KH' => "Cambodia",
        'KI' => "Kiribati",
        'KM' => "Comoros",
        'KN' => "St. Kitts",
        'KP' => "Korea",
        'KR' => "Korea",
        'KV' => "Kosovo",
        'KW' => "Kuwait",
        'KY' => "Cayman Islands",
        'KZ' => "Kazakhstan",
        'LA' => "Lao People's Democratic Republic",
        'LB' => "Lebanon",
        'LC' => "St. Lucia",
        'LI' => "Liechtenstein",
        'LK' => "Sri Lanka",
        'LR' => "Liberia",
        'LS' => "Lesotho",
        'LT' => "Lithuania",
        'LU' => "Luxembourg",
        'LV' => "Latvia",
        'LY' => "Libya",
        'MA' => "Morocco",
        'MC' => "Monaco",
        'MD' => "Moldova",
        'ME' => "Montenegro",
        'MG' => "Madagascar",
        'MH' => "Marshall Islands",
        'MK' => "Macedonia",
        'ML' => "Mali",
        'MM' => "Myanmar",
        'MN' => "Mongolia",
        'MO' => "Macau",
        'MP' => "Saipan",
        'MQ' => "Martinique",
        'MR' => "Mauritania",
        'MS' => "Montserrat",
        'MT' => "Malta",
        'MU' => "Mauritius",
        'MV' => "Maldives",
        'MW' => "Malawi",
        'MX' => "Mexico",
        'MY' => "Malaysia",
        'MZ' => "Mozambique",
        'NA' => "Namibia",
        'NC' => "New Caledonia",
        'NE' => "Niger",
        'NG' => "Nigeria",
        'NI' => "Nicaragua",
        'NL' => "Netherlands",
        'NO' => "Norway",
        'NP' => "Nepal",
        'NR' => "Nauru",
        'NU' => "Niue",
        'NZ' => "New Zealand",
        'OM' => "Oman",
        'PA' => "Panama",
        'PE' => "Peru",
        'PF' => "Tahiti",
        'PG' => "Papua New Guinea",
        'PH' => "Philippines",
        'PK' => "Pakistan",
        'PL' => "Poland",
        'PR' => "Puerto Rico",
        'PT' => "Portugal",
        'PW' => "Palau",
        'PY' => "Paraguay",
        'QA' => "Qatar",
        'RE' => "Reunion",
        'RO' => "Romania",
        'RS' => "Serbia",
        'RU' => "Russian Federation",
        'RW' => "Rwanda",
        'SA' => "Saudi Arabia",
        'SB' => "Solomon Islands",
        'SC' => "Seychelles",
        'SD' => "Sudan",
        'SE' => "Sweden",
        'SG' => "Singapore",
        'SH' => "SAINT HELENA",
        'SI' => "Slovenia",
        'SK' => "Slovakia",
        'SL' => "Sierra Leone",
        'SM' => "San Marino",
        'SN' => "Senegal",
        'SO' => "Somalia",
        'SR' => "Suriname",
        'SS' => "SOUTH SUDAN",
        'ST' => "Sao Tome and Principe",
        'SV' => "El Salvador",
        'SY' => "Syria",
        'SZ' => "Swaziland",
        'TC' => "Turks and Caicos Islands",
        'TD' => "Chad",
        'TG' => "Togo",
        'TH' => "Thailand",
        'TJ' => "Tajikistan",
        'TL' => "East Timor",
        'TN' => "Tunisia",
        'TO' => "Tonga",
        'TR' => "Turkey",
        'TT' => "Trinidad and Tobago",
        'TV' => "Tuvalu",
        'TW' => "Taiwan",
        'TZ' => "Tanzania",
        'UA' => "Ukraine",
        'UG' => "Uganda",
        'US' => "United States Of America",
        'UY' => "Uruguay",
        'UZ' => "Uzbekistan",
        'VC' => "St. Vincent",
        'VE' => "Venezuela",
        'VG' => "Virgin Islands (British)",
        'VI' => "Virgin Islands (US)",
        'VN' => "Vietnam",
        'VU' => "Vanuatu",
        'WS' => "Samoa",
        'XB' => "Bonaire",
        'XC' => "Curacao",
        'XE' => "St. Eustatius",
        'XM' => "St. Maarten",
        'XN' => "Nevis",
        'XS' => "Somaliland",
        'XY' => "St. Barthelemy",
        'YE' => "Yemen",
        'YT' => "Mayotte",
        'ZA' => "South Africa",
        'ZM' => "Zambia",
        'ZW' => "Zimbabwe",
      }

      DHL_Countries_With_Imperial_Units = # notably the US is missing - maybe DHL uses metric for the US internally?
        %w[AF AO AT AZ BI BN BT CR CU DM EE GA GD GH HR IC IL KE KR MN PF PY RW SC SE SG SL SM SN SO SR ST]
        
      DoorTo = {
        'DD' => "Door to Door",
        'DA' => "Door to Airport",
        'AA' => 'Door to Dor non-compliant',
        'AA' => 'Door to Dor non-compliant'
      }

      def requirements
        [:login, :password, :account_number, :return_service,
          :global_product_code, :local_product_code, :door_to]
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

        xml = begin
          REXML::Document.new(response)
        rescue REXML::ParseException
          REXML::Document.new(response.force_encoding("ISO-8859-1").encode("UTF-8"))
        end
        success = response_success?(xml)

        if success
          tracking_number = xml.get_text('//AirwayBillNumber').value
          image_data = Base64::decode64(xml.get_text("//LabelImage/OutputImage").to_s)
        else
          message = response_message(xml)
        end
        
        hsh = begin
          Hash.from_xml(response)
        rescue REXML::ParseException
          Hash.from_xml(response.force_encoding("ISO-8859-1").encode("UTF-8"))
        end
        LabelResponse.new(success, message, hsh, {
          :labels => [Label.new(
            tracking_number,
            image_data
          )]
        })
      end

      def response_success?(document)
        document.get_text("//Note/ActionNote").try(:value) == "Success"
      end

      def response_message(document)
        document.get_text("//ConditionData").value
      end

      protected

      def imperial?(country_code = ::TC_COUNTRY_CODE)
        DHL_Countries_With_Imperial_Units.include? country_code.strip.upcase
      end

      def build_label_request(origin, destination, packages, options)
        xml = Builder::XmlMarkup.new

        xml.instruct!

        xml.req :ShipmentValidateRequestEA, "xmlns:req" => "http://www.dhl.com", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.dhl.com ship-val-req_EA.xsd" do
          xml.Request do
            xml.ServiceHeader do
              xml.MessageTime Time.now.iso8601
              xml.MessageReference '1234567890123456789012345678901' #TODO: A string, peferably number, to uniquely identify individual messages. Minimum length must be 28 and maximum length is 32
              # The Message Reference element should contain a unique reference to the message, so that trace of a particular message can easily be carried out. It must be of minimum length of 28 and maximum 32. The value can be decided by the customer.
              xml.SiteID @options[:login]
              xml.Password @options[:password]
            end
          end
          xml.NewShipper 'N'
          xml.LanguageCode 'en'
          xml.PiecesEnabled 'Y'
          xml.Billing do
            xml.ShipperAccountNumber @options[:account_number]
            xml.ShippingPaymentType PaymentTypes[ ( @options[:return_service] ? 'receiver' : 'shipper' ) ]
            xml.BillingAccountNumber @options[:account_number]  if @options[:return_service]
          end
          xml.Consignee do #destination
            xml.CompanyName destination.company_name[0...35]
            xml.AddressLine destination.address1[0...35]
            xml.AddressLine destination.address2[0...35]  if destination.address2.present?
            xml.AddressLine destination.address3[0...35]  if destination.address3.present?
            xml.City destination.city[0...35]
            xml.Division destination.state[0...35]  if destination.state.present?
            xml.PostalCode destination.zip
            xml.CountryCode destination.country_code
            xml.CountryName DHL_Country_Codes[destination.country_code]
            xml.Contact do
              xml.PersonName destination.name[0...35]
              xml.PhoneNumber destination.phone.present? ? destination.phone[0...25] : "NA"
            end
          end
          #xml.Reference #TODO?
          xml.ShipmentDetails do # optional
            xml.NumberOfPieces packages.count
            xml.CurrencyCode DHL_Currency_Codes[destination.country_code]
            total_weight = 0
            xml.Pieces do
              for package_number in (1..packages.count) do
                pkg = packages[ package_number - 1 ]
                xml.Piece do
                  xml.PieceID package_number
                  #xml.PackageType 'CP' # custom packaging # optional
                  xml.Weight (imperial? ? pkg.lbs : pkg.kgs).round 3
                  total_weight += imperial? ? pkg.lbs : pkg.kgs
                  xml.Depth (imperial? ? pkg.inches(:length) : pkg.cm(:length)).round
                  xml.Width (imperial? ? pkg.inches(:width) : pkg.cm(:width)).round
                  xml.Height (imperial? ? pkg.inches(:height) : pkg.cm(:height)).round
                end
              end
            end
            xml.PackageType 'CP' # custom packaging
            xml.Weight total_weight.round 3
            xml.DimensionUnit imperial? ? 'I' : 'C'
            xml.WeightUnit imperial? ? 'L' : 'K'
            xml.GlobalProductCode @options[:global_product_code]
            xml.LocalProductCode @options[:local_product_code]
            xml.DoorTo @options[:door_to]
            xml.Date (Date.today + 1).iso8601
            xml.Contents options[:brigade_unit_name]
          end
          xml.Shipper do
            xml.ShipperID @options[:account_number] #as per instruction from Lionel Brendlin
            xml.CompanyName origin.company_name[0...35]
            xml.RegisteredAccount @options[:account_number]
            xml.AddressLine origin.address1[0...35]
            xml.AddressLine origin.address2[0...35]  if origin.address2.present?
            xml.AddressLine origin.address3[0...35]  if origin.address3.present?
            xml.City origin.city[0...35]
            xml.Division origin.state[0...35]  if origin.state.present?
            xml.PostalCode origin.zip
            xml.CountryCode origin.country_code
            xml.CountryName DHL_Country_Codes[origin.country_code]
            xml.Contact do
              xml.PersonName origin.name[0...35]
              xml.PhoneNumber origin.phone.present? ? origin.phone[0...25] : "NA"
            end
          end
          xml.SpecialService do
            xml.SpecialServiceType 'PV' # label expiration: PT = 3 months, PU = 6 months, PV = 12 months, PW = 24 months
          end
          xml.EProcShip 'N'
          xml.LabelImageFormat 'PDF'
          xml.RequestArchiveDoc 'N'
        end

      end

      def commit(request, test = false)
        ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))
      end

    end
  end




end
