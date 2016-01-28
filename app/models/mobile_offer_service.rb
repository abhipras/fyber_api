require 'digest/sha1'
require 'net/http'
### Service object which deals with the controller request and
### makes request to Fyber API to retrive mobile offers or
### exit gracefully
class MobileOfferService
  include ActiveModel::Validations

  attr_accessor :uid, :pub0, :page

  validates_presence_of :uid, :pub0, :page

  API_CONSTANTS = {
    app_id: 157,
    device_id: '2b6f0cc904d137be2e1730235f5664094b83',
    ip: '109.235.143.113',
    locale: 'de',
    offer_types: 112
  }

  API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'

  API_URL = 'http://api.fyber.com/feed/v1/offers.json'

  def initialize(options = {})
    self.uid = options[:uid]
    self.page = options[:page]
    self.pub0 = options[:pub0]
  end

  def show_mobile_offers
    msg = 'Validations failed with msg: ' + errors.messages.to_s
    fail StandardError, msg unless self.valid?
    params_str = api_params_hash.to_query
    uri_str = URI.parse(URI.encode(API_URL + '/?' + params_str))
    response = Net::HTTP.get_response(uri_str)
    body = JSON.parse(response.body).with_indifferent_access
    handle_response(body.with_indifferent_access)
  end

  def api_params_hash
    params_hash = {}
    params_hash = params_hash.merge!(API_CONSTANTS)
    params_hash[:page] = page
    params_hash[:pub0] = pub0
    params_hash[:uid] = uid
    sha1 = Digest::SHA1.hexdigest params_hash.to_query
    params_hash[:hashkey] = sha1
    params_hash
  end

  def handle_response(response_body)
    body, status = nil
    if check_response_hash(response_body)
      body = form_response_body(response_body[:offers])
      status = 200
    else
      body = { error: 'Not a valid response from the api server' }
      status = 400
    end
    [body, status]
  end

  def form_response_body(offers)
    body = []
    offers.each do |offer|
      body.push(title: offer[:title],
                payout: offer[:payout],
                img: offer[:thumbnail][:lowres])
    end
    body
  end

  ### Checks the following conditions in the response body
  ### offers key should exist. If it exists, it should be an Array
  ### It can either be an empty or a non empty array
  ### If its non empty check if it has the keys title, payout or thumbnail
  ### the thumbail key should be a hash, if its a hash check if it has a key
  ### lowres
  def check_response_hash(body)
    body.keys.include?('offers') &&  ### Check if offers key exists
      body[:offers].is_a?(Array) &&  ### Check if offers is an Array
      (body[:offers].first.nil? || ### Check if first elem of offers is nil or
          (body[:offers].first.keys.include?('title') && ### If the first elem exists check if first elem contains the key title
          body[:offers].first.keys.include?('payout') && ### check if first elem contains the key payout
          body[:offers].first.keys.include?('thumbnail') && ### check if first elem contains the key thumbnail
          body[:offers].first[:thumbnail].is_a?(Hash) && ### check if value corresponding to the key thumbnail is a Hash
          body[:offers].first[:thumbnail].keys.include?('lowres'))) ### check if value corresponding to the key thumbnail contains the key lowres
  end
end
