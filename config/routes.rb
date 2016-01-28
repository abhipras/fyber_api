Rails.application.routes.draw do
  root 'mobile_offers#index'
  get 'mobile_offers', to: 'mobile_offers#show'
end
