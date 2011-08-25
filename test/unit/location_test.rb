require 'test_helper'

class LocationTest < Test::Unit::TestCase
  include ActiveMerchant::Shipping
  
  def setup
    @locations = TestFixtures.locations.dup
  end

  def test_countries
    assert_instance_of ActiveMerchant::Country, @locations[:ottawa].country
    assert_equal 'CA', @locations[:ottawa].country_code(:alpha2)
  end
  
  def test_location_from_strange_hash
    hash = {  :country => 'CA',
              :zip => '90210',
              :territory_code => 'QC', 
              :town => 'Perth',
              :address => '66 Gregory Ave.', 
              :phone => '515-555-1212',
              :fax_number => 'none to speak of',
              :address_type => :commercial,
              :company_name => 'Footronics',
              :attention_name => 'Joey Joe Joe Junior Shabadoo',
              :tax_id_number => '555-555-555'
            }
    location = Location.from(hash)
    
    assert_equal hash[:country], location.country_code(:alpha2)
    assert_equal hash[:zip], location.zip
    assert_equal hash[:territory_code], location.province
    assert_equal hash[:town], location.city
    assert_equal hash[:address], location.address1
    assert_equal hash[:phone], location.phone
    assert_equal hash[:fax_number], location.fax
    assert_equal hash[:address_type].to_s, location.address_type
    assert_equal hash[:company_name], location.company_name
    assert_equal hash[:attention_name], location.attention_name
    assert_equal hash[:tax_id_number], location.tax_id_number
  end
  
  def to_s
    expected = "110 Laurier Avenue West\nOttawa, ON, K1P 1J1\nCanada"
    assert_equal expected, @locations[:ottawa].to_s
  end
  
  def test_inspect
    expected = "110 Laurier Avenue West\nOttawa, ON, K1P 1J1\nCanada\nPhone: 1-613-580-2400\nFax: 1-613-580-2495"
    assert_equal expected, @locations[:ottawa].inspect
  end
  
  def test_includes_name
    location = Location.from(:name => "Bob Bobsen")
    assert_equal "Bob Bobsen", location.name
  end
  
  def test_name_is_nil_if_not_provided
    location = Location.from({})
    assert_nil location.name
  end
end