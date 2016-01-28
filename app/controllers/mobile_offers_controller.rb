### Main controller which handles the requests to show
### index pages and the mobile offers page
class MobileOffersController < ApplicationController
  def index
  end

  def show
    service = MobileOfferService.new(params)
    @offers, @code = service.show_mobile_offers
  end
end
