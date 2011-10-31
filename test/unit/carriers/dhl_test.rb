require 'test_helper'

class DhlTest < Test::Unit::TestCase
  def setup
    @packages               = TestFixtures.packages
    @locations              = TestFixtures.locations
    @carrier                = Dhl.new(:login => 'powerupxml',
    :password => '5vec67d78a',
    :account_number => '272317228',
    :test => true)

    @germany = Location.new(:country => 'BE',
    :company_name => 'Company',
    :state => '',
    :city => 'Berlin',
    :address1 => 'Rosenthaler Str. 40/41',
    :postal_code => '180asdfas0',
    :phone => '1-613-580-2400',
    :fax => '1-613-580-2495',
    :country => 'Belgium')
  end

  def test_initialize_options_requirements
    assert_raises ArgumentError do Dhl.new end
    assert_raises ArgumentError do Dhl.new(:login => '999999999') end
    assert_raises ArgumentError do Dhl.new(:password => '7777777') end
    assert_nothing_raised {   Dhl.new(:login => 'powerupxml',
      :password => '5vec67d78a',
      :account_number => '272317228',
    :test => true)}
  end

  # def test_generate_label
  #   expected_request = xml_fixture('dhl/ship_validate_request_europe')
  #   mock_response = xml_fixture('dhl/ship_validate_response_europe')
  #   Time.any_instance.expects(:to_xml_value).returns("2009-07-20T12:01:55-04:00")
  #   @carrier.expects(:commit).with {|request, test_mode| Hash.from_xml(request) == Hash.from_xml(expected_request) && test_mode}.returns(mock_response)
  # end

  def test_generate_label



    # mock_response = xml_fixture('dhl/ship_validate_response_europe')
    # @carrier.stubs(:commit).returns(mock_response)
    # response = @carrier.generate_label(@germany,
    #                         @locations[:beverly_hills],
    #                         @packages.values_at(:book, :wii), {:payment_type => 'S',
    #                                                            :package_type => 'EE',
    #                                                            :global_product_code => '0',
    #                                                            :door_to => 'DD',
    #                                                            :content => 'Sample ',
    #                                                            :shipper_id => '272317228'})
    # assert_instance_of LabelResponse, response
  end

  def test_parse_response
    mock_response = xml_fixture('dhl/ship_validate_response_europe_success')
    parsed_label = @carrier.parse_label_response(mock_response)

    # assert parsed_label.success?
    assert_equal 'LOGISTICS SERVICES', parsed_label.product_name
    assert_equal 'LOG', parsed_label.product_content_code
    assert_equal '131297', parsed_label.unit_id
    assert_equal '2011-10-07', parsed_label.shipment_date
    assert_equal 'BRU', parsed_label.service_area_code
    assert_equal 'Company', parsed_label.shipper_company_name
    assert_equal 'Rosenthaler Str. 40/41',  parsed_label.shipper_address_1
    assert_equal  'Berlin', parsed_label.shipper_city
    assert_equal  '', parsed_label.shipper_division
    assert_equal  '1800', parsed_label.shipper_postal_code
    assert_equal  'Belgium',parsed_label.shipper_country
    assert_equal  'Prasanta Sinha', parsed_label.shipper_contact_name
    assert_equal  '11234-325423', parsed_label.shipper_contact_phone
    assert_equal  'ELA', parsed_label.origin_service_area
    assert_equal 'Company', parsed_label.receiver_company_name
    assert_equal '455 N. Rexford Dr.', parsed_label.receiver_address_1
    assert_equal '3rd Floor', parsed_label.receiver_address_2
    assert_equal 'Beverly Hills', parsed_label.receiver_city
    assert_equal 'CA', parsed_label.receiver_division
    assert_equal '90210', parsed_label.receiver_postal_code
    assert_equal 'United States', parsed_label.receiver_country
    assert_equal 'Tim Case', parsed_label.receiver_contact_name
    assert_equal '1-310-285-1013', parsed_label.receiver_contact_phone
    assert_equal '', parsed_label.outbound_sort_code
    assert_equal 'ELA', parsed_label.destination_facility_code
    assert_equal '', parsed_label.inbound_sort_code
    assert_equal 'a548a12074ee4e8ea80300001e0b0001', parsed_label.message_reference
    assert_equal '272317228', parsed_label.account_number
    assert_equal '370.0', parsed_label.weight
    assert_equal 'K', parsed_label.weight_unit
    assert_equal 'iVBORw0KGgoAAAANSUhEUgAAAYwAAABeAQMAAAAKdrGZAAAABlBMVEX///8AAABVwtN+AAAAaUlEQVR42mNkYGBIyL8w5a9P8IWJZmIBwSKbq2b+8laauYAtvSzgq5G3xsquKO9zbxeE9wR8vTdfaQEDAxMDyWBUy6iWUS2jWka1jGoZ1TKqZVTLqJZRLaNaRrWMahnVMqplVMuoFlIBAL0FFryEW9x8AAAAAElFTkSuQmCC', parsed_label.awb_barcode
    assert_equal 'iVBORw0KGgoAAAANSUhEUgAAATUAAABeAQMAAAB4lRFqAAAABlBMVEX///8AAABVwtN+AAAAU0lEQVR42mNkYGBIyL8whVsJRJx7Y82w5amONcPmqpm/bM1Tvxp9rsq/MPECAwMTA3FgVN2oulF1o+pG1Y2qG1U3qm5U3ai6UXWj6kbVjaqjhjoAwkkRvIJWgT4AAAAASUVORK5CYII=', parsed_label.origin_destination_barcode
    assert_equal 'iVBORw0KGgoAAAANSUhEUgAAAcIAAABeAQMAAACKBYaKAAAABlBMVEX///8AAABVwtN+AAAAcklEQVR42u3LoQ2DQABG4f9Ijio0OcUm6M7ABCiQTXOiJ+sxBEFgHLY4CRs0QVBmwJG8J1/yGUnvzMe8mfsjag/fV1v8TBFUraZ8arBdtL5WOik/nx5u+YybC1KiqyGRSCQSiUQikUgkEolEIpFI5N3kH9EXFLzg6sMzAAAAAElFTkSuQmCC', parsed_label.dhl_routing_barcode
    assert_equal "YYYY-MM-DD", parsed_label.reference_data
    assert_equal 'C', parsed_label.service_features_code
    assert_equal "NOEEI 30.37(a)", parsed_label.eei
    assert_equal "1/1", parsed_label.piece
  end

  # def test_generate_label
  #   mock_response = xml_fixture('dhl/ship_validate_response_europe')
  #   @carrier.stubs(:commit).returns(mock_response)
  #   response = @carrier.generate_label(@locations[:ottawa],
  #                           @locations[:beverly_hills],
  #                           @packages.values_at(:book, :wii), :test => true)
  #   assert_instance_of LabelResponse, response
  # end
end
