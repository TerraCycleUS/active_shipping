require 'test_helper'

class DhlTest < Test::Unit::TestCase
  def setup
    @packages               = TestFixtures.packages
    @locations              = TestFixtures.locations
    @carrier                = Dhl.new(:login => 'powerupxml',
    :password => '5vec67d78a',
    :account_number => '272317228',
    :test => true)

    @germany1 = Location.new(:country_code => 'DE',
    :company_name => 'Starbucks',
    :state => '',
    :city => 'Berlin',
    :address1 => 'Rosenthaler Str. 40/41',
    :postal_code => '10178',
    :phone => '1-613-580-2400',
    :fax => '1-613-580-2495',
    :country => 'Belgium',
    :name => 'Michael Schumacher')
    
    @germany2 = Location.new(:country_code => 'DE',
    :company_name => 'Starbucks',
    :state => '',
    :city => 'Berlin',
    :address1 => 'Friedrichstr. 61',
    :postal_code => '10117',
    :phone => '1-613-580-2400',
    :fax => '1-613-580-2495',
    :country => 'Belgium',
    :name => 'Michael Schumacher')
    
    @belgium1 = Location.new(:country_code => "BE",
    :company_name => "McDonalds",
    :city => "Brussels",
    :address1 => "Elsensesteenweg 21",
    :postal_code => '1050',
    :phone => '32 2 513 51 93',
    :fax => '32 2 513 51 93',
    :country => 'Belgium',
    :name => 'Michael Schumacher')
    
    @belgium2 = Location.new(:country_code => "BE",
    :company_name => "McDonalds",
    :city => "Brussels",
    :address1 => "Place de la Bourse 3",
    :postal_code => '1000',
    :phone => '32 2 513 42 13',
    :fax => '32 2 513 42 13',
    :country => 'Belgium',
    :name => 'Michael Schumacher')
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


  def test_generate_label
    mock_response = xml_fixture('dhl/ship_validate_response_europe_success')
    @carrier.stubs(:commit).returns(mock_response)
    response = @carrier.generate_label(@germany1,
                            @germany2,
                            @packages.values_at(:book, :wii), {:payment_type => 'S',
                                                               :package_type => 'EE',
                                                               :global_product_code => 'N',
                                                               :local_product_code => 'C',
                                                               :door_to => 'DD',
                                                               :content => 'Sample ',
                                                               :shipper_id => '272317228'})
    assert_instance_of DhlLabelResponse, response
    assert response.success?
    assert_nil response.message
  end

  def test_parse_response
    mock_response = xml_fixture('dhl/ship_validate_response_europe_success')
    parsed_label = @carrier.parse_label_response(mock_response)
  
    assert parsed_label.success?
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
    assert_equal "41 4059 4496", parsed_label.airway_bill_number
    assert_equal "US90210+00000000", parsed_label.dhl_routing_code
    assert_equal '2L', parsed_label.dhl_routing_data_id
    assert_equal 'J', parsed_label.data_identifier
    assert_equal 'JD011 000 0000 0004 7093', parsed_label.license_plate
  end
  
  def test_failure_response
    mock_response = xml_fixture('dhl/ship_validate_response_europe_failure')
    @carrier.stubs(:commit).returns(mock_response)
    response = @carrier.generate_label(@germany1,
                            @germany2,
                            @packages.values_at(:book, :wii), {:payment_type => 'S',
                                                               :package_type => 'EE',
                                                               :global_product_code => 'N',
                                                               :local_product_code => 'C',
                                                               :door_to => 'DD',
                                                               :content => 'Sample ',
                                                               :shipper_id => '272317228'})
    assert_instance_of DhlLabelResponse, response
    assert !response.success?
    assert_match /SV011a/, response.message
    assert_match /Cannot determine destination service/, response.message
    
  end
end
