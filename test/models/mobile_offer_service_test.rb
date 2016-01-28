### Test cases for the mobile offers API
require 'test_helper'
include WebMock::API

class MobileOfferServiceTest < ActiveSupport::TestCase
  FIXED_ATTRS = [:app_id, :device_id, :ip, :locale, :offer_types]
  INSTANCE_ATTRS = [:pub0, :page, :uid]
  KEYS = FIXED_ATTRS + INSTANCE_ATTRS
  OUTPUT_ATTRS = [:title, :payout, :thumbnail]

  def setup
    options = { uid: 2, pub0: 'user', page: 10 }
    @mb = MobileOfferService.new options
    json = "{\"code\":\" OK\",\"message\":\"OK\",\"count\":1,\"pages\":1,\"information\":{\"app_name\":\"SP Test App\",\"appid\":157,\"virtual_currency\":\"Coins\",\"country\":\" US\",\"language\":\" EN\",\"support_url\":\"http=>//iframe.fyber.com/mobile/DE/157/my_offers\"},\"offers\":[{\"title\":\"Tap  Fish\",\"offer_id\":13554,\"teaser\":\"Download and START\",\"required_actions\":\"Download and START\",\"link\":\"http://iframe.fyber.com/mbrowser?appid=157&lpid=11387&uid=player1\",\"offer_types\":[{\"offer_type_id\":101,\"readable\":\"Download\"},{\"offer_type_id\":112,\"readable\":\"Free\"}],\"thumbnail\":{\"lowres\":\"http://cdn.fyber.com/assets/1808/icon175x175-2_square_60.png\",\"hires\":\"http=>//cdn.fyber.com/assets/1808/icon175x175-2_square_175.png\"},\"payout\":90,\"time_to_payout\":{\"amount\":1800,\"readable\":\"30 minutes\"}}]}"
    @response_body = JSON.parse(json).with_indifferent_access
  end

  def test_presence_of_attributes
    INSTANCE_ATTRS.map do |key|
      test_presence_of_attributes_helper(key)
    end
    assert_equal @mb.valid?, true
  end

  def test_api_params_hash
    params_hash = @mb.api_params_hash
    assert KEYS.all? { |t| params_hash.key?(t) }
    assert params_hash.key?(:hashkey)
  end

  def test_handle_response
    _, status = @mb.handle_response(@response_body)
    assert_equal status, 200

    _, status = @mb.handle_response({})
    assert_equal status, 400
  end

  def test_check_response_hash
    body = @response_body
    assert @mb.check_response_hash(body)
    OUTPUT_ATTRS.map do |attr|
      test_check_response_hash_helper(attr)
    end
  end

  def test_show_mobile_offers_expected
    ### Test for correct response from the api server
    params_str = @mb.api_params_hash.to_query
    uri_str = MobileOfferService::API_URL + '/?' + params_str
    stub_request(:get, uri_str)
      .to_return(status: 200, body: @response_body.to_json)
    _, code = @mb.show_mobile_offers
    assert_equal code, 200
  end

  def test_show_mobile_offers_error
    ### Test for inccorrect response from the api server
    params_str = @mb.api_params_hash.to_query
    uri_str = MobileOfferService::API_URL + '/?' + params_str
    stub_request(:get, uri_str)
      .to_return(status: 400, body: {}.to_json)
    _, code = @mb.show_mobile_offers
    assert_equal code, 400
  end

  private

  def test_presence_of_attributes_helper(attr)
    obj = @mb.deep_dup
    obj.send("#{attr}=", nil)
    assert_equal obj.valid?, false
  end

  def test_check_response_hash_helper(attr)
    body = @response_body
    body[:offers].first.delete(attr)
    val = @mb.check_response_hash(body)
    assert_equal val, false
  end
end
