# A ruby based web app to see the mobile offers on Fyber given a page, pub0 and uid

To start
please run
```bash
bundle install
```

After the above steps, please start the server
```bash
rails s
```

Now go to the link
[Home page](http://localhost:3000/)


To run  the tests
please run
```bash
rake
```

# Design
`MobileOfferService` is a service object which accepts params from the frontend page, 
calls the Fyber API server and returns the array of values to be displayed on the frontend.
* Contains variables to be sent in the API as class constants such as `device_id`, `app_id` etc
* Dynamic variables to be sent in the API call are `page`, `pub0` and `uid` which are instance variables
* `check_response_hash` is a complex hash verifying method which verfies the presence of keys expected in the response from the API server
    * It sequentially checks every constraint 
* `form_response_body` forms an array of outputs from the response
* `api_params_hash` forms the hash corresponding to the `url_params`
* `handle_response` returns an error message if the response isn't correct and returns desired output and status code for correct mode of operation

`MobileOffersController` is the only controller which displays a form by default which accepts
parameters of `pub0`, `page` and `uid`, it renders a show page which has offers returned from the API server

All constants are defined in the `app/models/mobile_offer_service.rb`

