require 'test_helper'
require 'base64'
class SwissPostTest < Test::Unit::TestCase

  def setup
    @packages               = TestFixtures.packages
    @locations              = TestFixtures.locations
    # @carrier                = SwissPost.new(:login => 'TU_102243652_01',
    # :password => 'KgYv3Ycd3Z',
    # :franking_license => '60032862')
    
    @carrier = SwissPost.new(:login => 'TU_102243652_05',
                             :password => 'KS7Xygq4kR',
                             :franking_license => '60035407')

    @sender = Location.new(:name => "Musterfirma",
    :company_name => "Generalagentur",
    :address1 => 'Musterstrasse 9',
    :address2 => 'Postfach 600',
    :postal_code => '8000',
    :city => 'Musterhausen',
    :country => 'CH',
    :region => '3001 Bern')

    @recipient = Location.new(
    :title => 'Herr',
    :name => "Hans Muster",
    :company_name => "z.H. Vreni Muster",
    :address1 => 'Musterstrasse 1',
    :address2 => 'Postfach 400',
    :postal_code => '8000',
    :city => 'Musterhausen',
    :country => 'CH',
    :phone => '441234567',
    :mobile => '791234567',
    :email => 'hans.muster@muster.ch')
  end
  def test_initialize_options_requirements
    assert_raises ArgumentError do SwissPost.new end
    assert_raises ArgumentError do SwissPost.new(:login => '999999999') end
    assert_raises ArgumentError do SwissPost.new(:password => '7777777') end
    assert_raises ArgumentError do SwissPost.new(:franking_license => '272317228') end
    assert_nothing_raised { SwissPost.new(:login => '123', :password => '7777777', :franking_license => '123')}
  end



  def test_swiss_post
    assert true
  end


  def test_generate_label
    mock_response = xml_fixture('swisspost/generate_label_response')
    
    # @carrier.stubs(:commit).returns(mock_response)
    response = @carrier.generate_label(@sender, @recipient, @packages)
    assert_instance_of LabelResponse, response
    assert_equal '996003286200009055', response.labels.first.tracking_number
    assert_match /R0lGODlh1AbYBPIAAAAAAJnMzGaZZ/, response.labels.first.image_data
    assert response.success?
    assert_nil response.message
  end

  def test_error_response
    mock_response = xml_fixture('swisspost/error_response')
    @carrier.stubs(:commit).returns(mock_response)
    assert_raise(ActiveMerchant::Shipping::ResponseError) {@carrier.generate_label(@sender, @recipient, @packages)  }
  end



end
