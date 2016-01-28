### Test cases for the mobile offers controller
require 'test_helper'
include WebMock::API

class MobileOffersControllerTest < ActionController::TestCase
  test 'should get the index' do
    get :index
    assert_response :success
    assert_template :index
  end

  test 'should get the show' do
    params = { page: 1, uid: 'player1', pub0: 'campaign2' }
    @mb = MobileOfferService.new params
    params_str = @mb.api_params_hash.to_query
    uri_str = MobileOfferService::API_URL + '/?' + params_str
    stub_request(:get, uri_str)
      .to_return(status: 400, body: {}.to_json)
    get :show, params
    assert_template :show
  end
end
