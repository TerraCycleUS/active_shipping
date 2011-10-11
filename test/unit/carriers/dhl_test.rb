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
    parsed_label = @carrier.parse_label_response(mock_response, '')
    assert parsed_label.success?
    assert_equal '4140594496', parsed_label.tracking_number
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
